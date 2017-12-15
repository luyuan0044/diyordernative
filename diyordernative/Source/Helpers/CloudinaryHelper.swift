//
//  CloudinaryHelper.swift
//  GoopterBiz
//
//  Created by Richard Lu on 2017-06-14.
//  Copyright © 2017 Goopter Holdings Ltd. (http://www.goopter.com)
//

import Foundation
import Cloudinary

class CloudinaryHelper {
    
    //Mark: parameters
    static let cloudName = "goopter"
    static let apiKey = "765637931769717"
    static let apiSecret = "712hZIlhS78M32vmBXCjyIUBNCU"
    
    static let preset = "d7gq9bdz"
    
    static var cloudinary: CLDCloudinary? = nil
    
    private static func configuration () {
        let config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret, secure: true)
        cloudinary = CLDCloudinary (configuration: config)
    }
    
    static func upload (data: Data, uploadDest: String, progress: ((Float) -> Void)? = nil, complete: @escaping (Bool, String?) -> Void) {
        if cloudinary == nil {
            configuration()
        }
        
        let params = CLDUploadRequestParams ()
        let _ = params.setFolder(uploadDest)
        print("Upload Image to cloudinary in folder : \(uploadDest)")
        cloudinary?.createUploader().upload(data: data, uploadPreset: preset, params: params, progress: {
            prog in
            
            if progress != nil {
                let percentage = Float(prog.completedUnitCount)/Float(prog.totalUnitCount)
                print("loading \(prog.completedUnitCount) / \(prog.totalUnitCount)")
                
                progress! (Float(percentage))
            }
        }, completionHandler: {
            (result, error) in
            
            if error != nil {
                print(error!)
            } else {
                print(result!)
            }

            complete (error == nil, result?.publicId)
        })
    }
    
    static func getUrl (imageId: String, size: CGSize?) -> String? {
        if cloudinary == nil {
            configuration()
        }
        
        var result: String? = nil
        
        let transformation = CLDTransformation()
        transformation.setCrop(.limit).setQuality("auto").setFetchFormat("jpg")
        
        if size != nil {
            transformation
                .setWidth(Float(size!.width))
                .setHeight(Float(size!.height))
        }
        
        result = cloudinary!.createUrl().setTransformation(transformation).generate(imageId)
        
        return result
    }
}




