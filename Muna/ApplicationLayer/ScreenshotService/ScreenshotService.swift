//
//  ScreenshotService.swift
//  Muna
//
//  Created by Egor Petrov on 10.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ScreenshotServiceProtocol {
    func makeScreenshot(inRect rect: CGRect) -> NSImage?
}

final class ScreenshotService: ScreenshotServiceProtocol {
    private let directoryURL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("ReminderPictures")

    private var mainDisplayID: CGDirectDisplayID {
        return CGMainDisplayID()
    }

    func makeScreenshot(inRect rect: CGRect) -> NSImage? {
        guard let cgImage = CGDisplayCreateImage(self.mainDisplayID, rect: rect) else {
            return nil
        }
        let image = NSImage(cgImage: cgImage, size: rect.size)
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        let jpgData = bitmap.representation(using: .jpeg, properties: [:])
        do {
            try jpgData?.write(to: self.directoryURL.appendingPathComponent("new.jpg"), options: .atomic)
        } catch {
            print(error)
        }
        return image
    }
}
