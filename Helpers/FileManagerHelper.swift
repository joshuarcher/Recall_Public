//
//  FileManagerHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 1/7/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import Foundation
import UIKit


class FileManager {
    
    static let imagesPath = "images"
    
    static let fileManager = NSFileManager.defaultManager()
    
    static func createDirectoryIfNeeded() -> NSURL {
        let docPath = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let imgPath = docPath.URLByAppendingPathComponent(imagesPath)
        
        do {
            try fileManager.createDirectoryAtURL(imgPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Error creating file path for images: %@", error)
        }
        
        return imgPath
    }
    
    static func saveImageData(toPath path: String?, data: NSData) {
        guard let path = path else {
            NSLog("Error saving image data")
            return
        }
        let imagesPath = createDirectoryIfNeeded()
        let newImagePath = imagesPath.URLByAppendingPathComponent(path)
        if let path = newImagePath.path {
            fileManager.createFileAtPath(path, contents: data, attributes: nil)
        } else {
            print("file not saved")
        }
    }
    
    static func deleteImageData(atPath path: String?) {
        guard let path = path else {
            NSLog("error deleting image data")
            return
        }
        let imagesPath = createDirectoryIfNeeded()
        let oldImagePath = imagesPath.URLByAppendingPathComponent(path)
        if let path = oldImagePath.path {
            do {
                try fileManager.removeItemAtPath(path)
            } catch let error as NSError {
                NSLog("Error deleting image data: %@", error)
            }
        }
    }
    
    static func getImage(fromPath path: String?) -> UIImage? {
        guard let path = path else {return nil}
        var image: UIImage?
        let docPath = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let imgPath = docPath.URLByAppendingPathComponent(imagesPath)
        let grabbingImage = imgPath.URLByAppendingPathComponent(path)
        guard let imageAsset = grabbingImage.path else {print("no image asset");return nil}
        
        if fileManager.fileExistsAtPath(imageAsset) {
            if let data = fileManager.contentsAtPath(imageAsset) as NSData? {
                image = UIImage(data: data)
            }
        } else {
            print("No image at path")
        }
        
        return image
    }
    
    
    
}
