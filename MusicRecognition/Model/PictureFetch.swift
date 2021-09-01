//
//  PictureFetch.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/25/21.
//

import Foundation
import UIKit

struct PictureFetch{
    
    private let picURLString:String?
    private let fileManager = FileManager.default
    
    init(_ picURLString:String?){
        self.picURLString = picURLString
    }
    
    var image:UIImage{
        
        return getPicture()
    }
    
    private var picURL:URL{
        return URL(string: picURLString!)!
    }
    
    private var fileName:String{
        
        guard let picURL = URL(string: picURLString!) else{
            return String()
        }
        return picURL.lastPathComponent
        
    }
    
    private func getPicture() -> UIImage{
        
        guard picURLString != nil else{
            //default image
            return UIImage(named: "blueprint")!
        }
        
        return checkForImage()
        
    }
    
    //func saveImage
    
    private func checkForImage() -> UIImage{
        
        var image = UIImage()
        var data = Data()
        
        do{
            let caches = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let pictureDirectory = caches.appendingPathComponent("Music Recognition").appendingPathComponent("Pictures")
            
            if !fileManager.fileExists(atPath: pictureDirectory.path){
                try fileManager.createDirectory(at: pictureDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            //see if picture exists
            let currentPath = pictureDirectory.appendingPathComponent("/\(fileName)")
                
            if fileManager.fileExists(atPath: currentPath.path){
                data = fileManager.contents(atPath: currentPath.path)!
                image = UIImage(data: data)!
            }else{
                //DispatchQueue.main.async {
                    do{
                        data = try Data(contentsOf: picURL)
                        fileManager.createFile(atPath: currentPath.path, contents: data, attributes: nil)
                        image = UIImage(data: data)!
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                //}
                
                
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return image
        
    }
    


    
    
}
