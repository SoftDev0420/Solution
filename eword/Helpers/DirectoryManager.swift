//
//  DirectoryManager.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

class DirectoryManager {
    static let instance = DirectoryManager()
    
    func addSkipBackupAttributeToItemAtURL(url: URL) -> Bool {
        assert(FileManager.default.fileExists(atPath: url.path))
        do {
            try (url as NSURL).setResourceValue(true, forKey: .isExcludedFromBackupKey)
            return true
        }
        catch {
            print("addSkipBackupAttributeToItemAtURL error")
            return false
        }
    }
    
    func doesFileExistAtPath(folderName: String, fileName: String) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var path = (paths[0] as NSString).appendingPathComponent(folderName)
        _ = addSkipBackupAttributeToItemAtURL(url: URL.init(fileURLWithPath: path))
        path = (path as NSString).appendingPathComponent(fileName)
        if (FileManager.default.fileExists(atPath: path)) {
            return true
        }
        else {
            return false
        }
    }
    
    func deleteFileAtPath(folderName: String, fileName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var path = paths[0]
        if (folderName.characters.count > 0) {
            path = (path as NSString).appendingPathComponent(folderName)
        }
        path = (path as NSString).appendingPathComponent(fileName)
        
        if (FileManager.default.fileExists(atPath: path as String)) {
            do {
                try FileManager.default.removeItem(atPath: path as String)
            }
            catch {
                print("deleteFileAtPath error")
            }
        }
    }
    
    func deleteFolderAtPath(folderName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = (paths[0] as NSString).appendingPathComponent(folderName)
        if (FileManager.default.fileExists(atPath: path)) {
            do {
                try FileManager.default.removeItem(atPath: path)
            }
            catch {
                print("deleteFolderAtPath error")
            }
        }
    }
    
    func createFolderForType(type: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = (paths[0] as NSString).appendingPathComponent(type)
        if (!FileManager.default.fileExists(atPath: path)) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("createFolderForType error")
            }
        }
    }
    
    func saveDataAtDirectoryForType(type: String, name: String, fileData: NSData) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectoryPath = paths[0] as NSString
        let folderPath = documentsDirectoryPath.appendingPathComponent(type)
        if (!FileManager.default.fileExists(atPath: folderPath)) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("saveDataAtDirectoryForType error")
            }
        }
        _ = addSkipBackupAttributeToItemAtURL(url: URL(fileURLWithPath: folderPath))
        let filePath = (folderPath as NSString).appendingPathComponent(name)
        if (FileManager.default.fileExists(atPath: filePath)) {
            deleteFileAtPath(folderName: type, fileName: name)
        }
        fileData.write(toFile: filePath, atomically: true)
    }
    
    func loadFileFromDirectoryForType(folderName: String, name: String) -> NSData? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var path = (paths[0] as NSString).appendingPathComponent(folderName)
        path = (path as NSString).appendingPathComponent(name)
        if (FileManager.default.fileExists(atPath: path)) {
            return NSData.init(contentsOfFile: path)
        }
        return nil
    }
    
    func listAllFilesForType(type: String) -> [String] {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = (paths[0] as NSString).appendingPathComponent(type)
        do {
            let directoryContent = try FileManager.default.contentsOfDirectory(atPath: path)
            return directoryContent
        }
        catch {
            return []
        }
    }
    
    func getPathForFileWithType(type: String?, name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        var folderPath = documentDirectory
        if (type != nil && type != "") {
            folderPath = (folderPath as NSString).appendingPathComponent(type!)
        }
        let filePath = (folderPath as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    func renameFileWithName(srcName: String, dstName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as NSString
        let folderPath = documentDirectory.appendingPathComponent("MyAudios") as NSString
        let filePathSrc = folderPath.appendingPathComponent(srcName)
        let filePathDst = folderPath.appendingPathComponent(dstName)
        
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: filePathSrc)) {
            do {
                try fileManager.removeItem(atPath: filePathDst)
            }
            catch {
                print("renameFileWithName error")
            }
            
            do {
                try fileManager.moveItem(atPath: filePathSrc, toPath: filePathDst)
            }
            catch {
                print("renameFileWithName error")
            }
        }
        else {
            print("renameFileWithName error")
        }
    }
    
    func copyFrom(source: String, destination: String) {
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: destination)) {
            do {
                try fileManager.removeItem(atPath: destination)
            }
            catch {
                print("copyFrom error")
            }
        }
        do {
            try fileManager.copyItem(atPath: source, toPath: destination)
        }
        catch {
            print("copyFrom error")
        }
    }
}
