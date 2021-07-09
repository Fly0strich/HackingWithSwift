//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Shae Willes on 7/9/21.
//

import UIKit

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contxtinfo: UnsafeRawPointer) {
        if error != nil {
            errorHandler?(error!)
        } else {
            successHandler?()
        }
    }
}
