//
//  AwsManager.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 18/10/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation
import AWSCore
import AWSMobileClient
import AWSS3


struct AwsManager {

    func uploadData(image: UIImage, name: String, token: [String:String]) {
        
        
        
        let data: Data = UIImagePNGRepresentation(
            resizeImage(image:image, targetSize: CGSize(width:200.0, height:200.0)))!
        
    
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                let networkManager: UserManager! = UserManager()
                
                let body = ["pictureUrl" : "https://s3.amazonaws.com/bquini-bucket/" + name] as [String:String]
                
                networkManager.editProfile(token: token, body: body) { (user, error) in
                    if let error = error {
                        print(error)
                    }
                    if let user = user {
                        userRepository = user
                    }
                }
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: "bquini-bucket",
                                   key: name,
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                    }
                                    return nil;
        }
    }
}


func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
