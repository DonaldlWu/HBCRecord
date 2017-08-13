//
//  UIImageViewExtensions.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/16.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCashWithUrlString(urlString: String) {
        
        // Check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                }
                
            }
            
        }.resume()
    }
}
