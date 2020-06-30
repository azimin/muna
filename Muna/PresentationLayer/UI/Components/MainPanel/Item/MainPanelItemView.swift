//
//  NewMainPanelItemView.swift
//  Muna
//
//  Created by Alexander on 6/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class MainPanelItemView: View, GenericCellSubview, ReusableComponent {
    enum Style {
        case basic
        case completed
    }

    private var style: Style = .basic

    private static var cachedHeight: [String: CGFloat] = [:]
    static var imageHeight: CGFloat = 172

    static func calculateHeight(item: ItemModel) -> CGFloat {
        if let height = self.cachedHeight[item.id] {
            return height
        }

        let height = MainPanelItemView.imageHeight + MainPanelItemMetainformationView.calculateHeight(item: item)

        self.cachedHeight[item.id] = height
        return height
    }

    let backgroundView = View()
    let selectionView = MainPanelItemSelectionView()
    var imageView = ImageView()
    var metainformationHeightConstraint: Constraint?

    let metainformationView = MainPanelItemMetainformationView()

    private var isComplited: Bool = false
    private var itemObservable: ObserverTokenProtocol?

    private var isSelected: Bool = false

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isFirstSetup = true
    let scaleTrasnform = CATransform3DConcat(CATransform3DMakeScale(0.93, 0.93, 1), CATransform3DMakeTranslation(8, 8, 0))

    override func layout() {
        super.layout()

        if self.isFirstSetup {
            self.isFirstSetup = false
            self.setSelected(self.isSelected, animated: false)
        }
    }

    func reuse() {
        self.item = nil
        self.itemObservable?.removeObserving()
    }

    override func updateLayer() {
        super.updateLayer()
    }

    private func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.backgroundColor = NSColor.white.withAlphaComponent(0.07)
        self.backgroundView.layer?.masksToBounds = true
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }

        self.backgroundView.addSubview(self.selectionView)
        self.selectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.imageView)
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.imageView.aspectRation = .resizeAspect
        self.imageView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(MainPanelItemView.imageHeight)
        }

        self.backgroundView.addSubview(self.metainformationView)
        self.metainformationView.snp.makeConstraints { maker in
            maker.top.equalTo(self.imageView.snp.bottom)
            maker.trailing.leading.bottom.equalToSuperview()
        }

        self.metainformationView.completionButton.target = self
        self.metainformationView.completionButton.action = #selector(self.toggleCompletion)
    }

    @objc
    func toggleCompletion() {
        self.isComplited.toggle()
        self.item?.isComplited = self.isComplited
        self.updateStyle()
    }

    func updateStyle() {
        let imageName = self.isComplited ? "reminder-on" : "reminder-off"
        self.metainformationView.completionButton.update(
            imageName: imageName,
            colorStyle: .titleAccent
        )
    }

    func setSelected(_ selected: Bool, animated: Bool) {
        self.isSelected = selected

        if selected {
            let transform = CATransform3DConcat(CATransform3DMakeScale(1, 1, 1), CATransform3DMakeTranslation(0, 0, 0))
            OperationQueue.main.addOperation {
                self.animateTransformation(transformValue: transform, animated: animated)
            }
            let alpha: CGFloat = Theme.current == .light ? 0.35 : 0.15
            self.backgroundView.backgroundColor = NSColor.color(.plateFullSelection).withAlphaComponent(alpha)
            self.selectionView.isHidden = false
        } else {
            let scale: CGFloat = 0.93
            let widthPaggination = (self.frame.width * (1 - scale)) / 2
            let heightPaggination = (self.frame.height * (1 - scale)) / 2
            let transform = CATransform3DConcat(CATransform3DMakeScale(scale, scale, 1), CATransform3DMakeTranslation(widthPaggination, heightPaggination, 0))
            OperationQueue.main.addOperation {
                self.animateTransformation(transformValue: transform, animated: animated)
            }
            let alpha: CGFloat = Theme.current == .light ? 0.15 : 0.07
            self.backgroundView.backgroundColor = NSColor.color(.plateFullSelection).withAlphaComponent(alpha)
            self.selectionView.isHidden = true
        }
    }

    func passMousePosition(point: CGPoint) {
        self.selectionView.passNewPosition(point: point)
    }

    func animateTransformation(transformValue: CATransform3D, animated: Bool) {
        guard animated else {
            self.backgroundView.layer?.transform = transformValue
            return
        }

        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.backgroundView.layer?.transform
        transform.toValue = transformValue
        transform.duration = 0.15
        self.backgroundView.layer?.transform = transformValue
        self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))
    }

    private var item: ItemModel?

    func update(item: ItemModel, style: Style) {
        self.style = style
        self.metainformationView.updateDueDate(item: item, style: style)

        if let comment = item.comment, comment.isEmpty == false {
            self.metainformationView.commentLabel.isHidden = false
        } else {
            self.metainformationView.commentLabel.isHidden = true
        }

        self.metainformationView.commentLabel.stringValue = item.comment ?? ""
        self.isComplited = item.isComplited

        let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: item.imageName)
        self.imageView.image = image

        self.item = item
        item.toggleSeen()

        self.updateStyle()

        self.itemObservable = ServiceLocator.shared.itemsDatabase.itemUpdated.observe(self, closure: { [weak self] _, id in
            guard let self = self else { return }
            if id != nil, self.item?.id == id {
                self.isComplited = item.isComplited
                self.updateStyle()
                self.metainformationView.updateDueDate(
                    item: item,
                    style: style
                )
            }
        })
    }
}

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}
