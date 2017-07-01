//
//  RecordPickerController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class RecordPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let recordtypeArray = ["H", "BB", "E", "K", "SF"]
    let dataArrayDescription = [["H", "2B", "3B", "HR"], ["BB", "HBP"], ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9"], ["K", "K"], ["SF", "SH"]]
    
    var recordPickerView: UIPickerView!
    var tempRecord: String = "H"
    var rowInRecordArray = Int()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(sendRecordBack), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(sendRecordCancel), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        recordPickerView = UIPickerView()
        recordPickerView.frame = CGRect(x: 0, y: self.view.bounds.height / 3, width: self.view.bounds.width, height: 200)
        recordPickerView.showsSelectionIndicator = true
        recordPickerView.delegate = self
        recordPickerView.dataSource = self
        
        self.view.addSubview(recordPickerView)
        self.view.addSubview(addButton)
        self.view.addSubview(cancelButton)
        
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 64).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -64).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

    }
    
    func sendRecordBack() {
        switch rowInRecordArray {
        case 0:
            recordArray0.append(tempRecord)
        case 1:
            recordArray1.append(tempRecord)
        case 2:
            recordArray2.append(tempRecord)
        case 3:
            recordArray3.append(tempRecord)
        case 4:
            recordArray4.append(tempRecord)
        case 5:
            recordArray5.append(tempRecord)
        case 6:
            recordArray6.append(tempRecord)
        case 7:
            recordArray7.append(tempRecord)
        case 8:
            recordArray8.append(tempRecord)
        default:
            return
        }
        let controller = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func sendRecordCancel() {
        let controller = RecordController(collectionViewLayout: UICollectionViewFlowLayout())
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if component == 0 {
            
            return recordtypeArray.count
        
        }
        print(dataArrayDescription[recordPickerView.selectedRow(inComponent: 0)].count)
        return dataArrayDescription[recordPickerView.selectedRow(inComponent: 0)].count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return recordtypeArray[row]
        
        }
        
        return dataArrayDescription[recordPickerView.selectedRow(inComponent: 0)][row]
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
        
            recordPickerView.reloadComponent(1)
            print(dataArrayDescription[row][0])
            tempRecord = dataArrayDescription[row][0]
        
        } else if component == 1 {
            
            print(dataArrayDescription[recordPickerView.selectedRow(inComponent: 0)][row])
            tempRecord = dataArrayDescription[recordPickerView.selectedRow(inComponent: 0)][row]
            
        }
        
        print("-------------------")
        print(row)
        print(component)
        print("-------------------")
        
    }
    
}