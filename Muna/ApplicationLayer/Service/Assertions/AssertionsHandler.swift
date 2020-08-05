//
//  AssertionsHandler.swift
//  Muna
//
//  Created by Alexander on 8/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public protocol AssertionErrorHandlerProtocol {
    func handleAssertion(error: NSError)
}

public class AssertionHandler {
    public var assertionErrorHandler: AssertionErrorHandlerProtocol?
    public init(assertionErrorHandler: AssertionErrorHandlerProtocol?) {
        self.assertionErrorHandler = assertionErrorHandler
    }
}

public func appAssert(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String,
    additionalInformation: String = "",
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
) {
    if !condition() {
        appAssertionFailure(
            message(),
            additionalInformation: additionalInformation,
            file: file,
            function: function,
            line: line
        )
    }
}

public func appAssertionFailure(
    _ message: @autoclosure () -> String,
    additionalInformation: String = "",
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
) {
    let output: String
    let fileName: String
    if let filename = URL(fileURLWithPath: file.description).lastPathComponent.components(separatedBy: ".").first {
        fileName = filename
        output = "\(filename).\(function) line \(line) $ \(message())"
    } else {
        fileName = "\(file)"
        output = "\(file).\(function) line \(line) $ \(message())"
    }
    let error = NSError(
        domain: "Assertion: " + message(),
        code: 1,
        userInfo:
        [
            "filename": fileName,
            "function": function,
            "line": line,
            "message": message(),
            "output": output,
            "additional_information": additionalInformation,
        ]
    )

    if let errorHandler = ServiceLocator.shared.assertionHandler.assertionErrorHandler {
        errorHandler.handleAssertion(error: error)
    } else {
        fatalError("No assertion error handler")
    }

    assertionFailure(message(), file: file, line: line)
}
