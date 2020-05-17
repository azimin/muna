import Foundation

// Be aware this is not thread safe!
// Why class? https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20160711/002580.html
class Observable<T> {
    init(_ value: T) {
        self.value = value
    }

    var value: T {
        didSet {
            self.cleanDeadObservers()
            for observer in self.observers {
                observer.closure(oldValue, self.value)
            }
        }
    }

    @discardableResult
    func observe(_ observer: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) -> ObserverToken<T> {
        let identifier = self.maxIdentifier + 1
        self.observers.append(Observer(owner: observer, identifier: identifier, closure: closure))
        self.cleanDeadObservers()
        return ObserverToken(observable: self, identifier: identifier)
    }

    @discardableResult
    func observeAndCall(_ observer: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) -> ObserverToken<T> {
        let value = self.observe(observer, closure: closure)
        closure(self.value, self.value)
        return value
    }

    func removeObserver(with id: Int) {
        if let index = self.observers.firstIndex(where: { $0.identifier == id }) {
            self.observers.remove(at: index)
        }
    }

    private var maxIdentifier: Int {
        let value = self.observers.reduce(0) { (result, paratemtr) -> Int in
            if paratemtr.identifier > result {
                return paratemtr.identifier
            }
            return result
        }
        return value
    }

    private func cleanDeadObservers() {
        self.observers = self.observers.filter { $0.owner != nil }
    }

    private lazy var observers = [Observer<T>]()
}

protocol ObserverTokenProtocol {
    func removeObserving()
}

class ObserverToken<T>: ObserverTokenProtocol {
    private let identifier: Int
    private weak var observable: Observable<T>?

    fileprivate init(observable: Observable<T>, identifier: Int) {
        self.observable = observable
        self.identifier = identifier
    }

    func removeObserving() {
        self.observable?.removeObserver(with: self.identifier)
    }
}

private struct Observer<T> {
    weak var owner: AnyObject?
    let identifier: Int
    let closure: (_ old: T, _ new: T) -> Void
    init(owner: AnyObject, identifier: Int, closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.owner = owner
        self.identifier = identifier
        self.closure = closure
    }
}

extension Observable where T: Equatable {
    @discardableResult
    func observeNew(_ observer: AnyObject, closure: @escaping (T) -> Void) -> ObserverToken<T> {
        return self.observe(observer) { old, new in
            guard old != new else { return }
            closure(new)
        }
    }

    @discardableResult
    func observeNewAndCall(_ observer: AnyObject, closure: @escaping (T) -> Void) -> ObserverToken<T> {
        let observer = self.observeNew(observer, closure: closure)
        closure(self.value)
        return observer
    }
}
