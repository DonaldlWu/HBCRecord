//
//  RecordPickerController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class RecordPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let recordtypeArray = ["H", "BB", "E", "K", "SC"]
    let dataArrayDescription = [["H", "2B", "3B", "HR"], ["BB", "HBP"], ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9"], ["K", "K"], ["SF", "SG"]]
    
    var recordPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        recordPickerView = UIPickerView()
        recordPickerView.frame = CGRect(x: 0, y: self.view.bounds.height / 2, width: self.view.bounds.width, height: 200)
        recordPickerView.showsSelectionIndicator = true
        recordPickerView.delegate = self
        recordPickerView.dataSource = self
        
        self.view.addSubview(recordPickerView)

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recordtypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recordtypeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select \(recordtypeArray[row])")
    }
    
}
