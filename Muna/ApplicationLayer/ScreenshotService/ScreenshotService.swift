//
//  ScreenshotService.swift
//  Muna
//
//  Created by Egor Petrov on 10.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ScreenshotServiceProtocol {
    func makeScreenshot(inRect rect: CGRect, name: String) -> NSImage?
}

final class ScreenshotService: ScreenshotServiceProtocol {
    private let directoryURL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("ReminderPictures", isDirectory: true)

    private var mainDisplayID: CGDirectDisplayID {
        return CGMainDisplayID()
    }

    func makeScreenshot(inRect rect: CGRect, name: String) -> NSImage? {
        guard let cgImage = CGDisplayCreateImage(self.mainDisplayID, rect: rect) else {
            return nil
        }
        let image = NSImage(cgImage: cgImage, size: rect.size)
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        let jpgData = bitmap.representation(using: .jpeg, properties: [:])
        do {
            try FileManager.default.createDirectory(at: self.directoryURL, withIntermediateDirectories: true, attributes: nil)
            try jpgData?.write(to: self.directoryURL.appendingPathComponent(name), options: .atomic)
        } catch {
            print(error)
        }
        return image
    }
}
