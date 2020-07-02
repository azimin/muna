//
//  ImageStorageService.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ImageStorageServiceProtocol {
    func urlOfImage(name: String) -> URL

    func saveImage(image: NSImage, name: String) -> Bool
    func saveImage(imageData: Data, name: String) -> Bool
    func loadImage(name: String, completion: ImageStorageService.Completion?)
    func forceLoadImage(name: String) -> NSImage?

    @discardableResult
    func removeImage(name: String) -> Bool
}

class ImageStorageService: ImageStorageServiceProtocol {
    typealias Completion = (NSImage?) -> Void

    func saveImage(image: NSImage, name: String) -> Bool {
        let data = image.tiffRepresentation(using: .jpeg, factor: 1.0)
        let directoryUrl = self.getDocumentsDirectory().appendingPathComponent("images")
        do {
            try FileManager.default.createDirectory(
                at: directoryUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try data?.write(to: directoryUrl.appendingPathComponent("\(name).jpeg"))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func saveImage(imageData: Data, name: String) -> Bool {
        let directoryUrl = self.getDocumentsDirectory().appendingPathComponent("images")
        do {
            try FileManager.default.createDirectory(
                at: directoryUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try imageData.write(to: directoryUrl.appendingPathComponent("\(name).jpeg"))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func urlOfImage(name: String) -> URL {
        let filePath = self.getDocumentsDirectory().appendingPathComponent("images/\(name).jpeg")
        return filePath
    }

    func loadImage(name: String, completion: Completion?) {
        completion?(self.forceLoadImage(name: name))
    }

    typealias CacheItem = (name: String, image: NSImage)
    private var cache: [CacheItem] = []

    func updateCacheIfNeeded() {
        if self.cache.count > 50 {
            self.cache.removeFirst(10)
        }
    }

    func forceLoadImage(name: String) -> NSImage? {
        self.updateCacheIfNeeded()
        if let image = self.cache.first(where: { $0.name == name })?.image {
            return image
        }

        let filename = self.getDocumentsDirectory().appendingPathComponent("images/\(name).jpeg")
        if let data = try? Data(contentsOf: filename) {
            let image = NSImage(data: data)
            if let image = image {
                self.cache.append((name, image))
            }
            return image
        } else {
            return nil
        }
    }

    func removeImage(name: String) -> Bool {
        let filename = self.getDocumentsDirectory().appendingPathComponent("images/\(name).jpeg")
        do {
            try FileManager.default.removeItem(at: filename)
            return true
        } catch {
            return false
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
