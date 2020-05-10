//
//  ImageStorageService.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ImageStorageServiceProtocol {
    func saveImage(image: NSImage, name: String) -> Bool
    func loadImage(name: String, completion: ImageStorageService.Completion?)
}

class ImageStorageService: ImageStorageServiceProtocol {
    typealias Completion = (NSImage?) -> Void

    func saveImage(image: NSImage, name: String) -> Bool {
        let data = image.tiffRepresentation(using: .jpeg, factor: 1.0)
        let filename = self.getDocumentsDirectory().appendingPathComponent("images/\(name).jpeg")
        do {
            try data?.write(to: filename)
            return true
        } catch {
            return false
        }
    }

    func loadImage(name: String, completion: Completion?) {
        let filename = self.getDocumentsDirectory().appendingPathComponent("images/\(name).jpeg")
        if let data = try? Data(contentsOf: filename) {
            let image = NSImage(data: data)
            completion?(image)
        } else {
            completion?(nil)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
