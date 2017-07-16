//
//  UIImageViewExtensions.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/7/16.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageUsingCashWithUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }.resume()
    }
}
