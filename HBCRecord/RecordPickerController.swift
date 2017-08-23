//
//  RecordPickerController.swift
//  HBCRecord
//
//  Created by 吳得人 on 2017/6/30.
//  Copyright © 2017年 吳得人. All rights reserved.
//

import UIKit

class RecordPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let recordtypeArray = ["H", "BB", "E", "K", "SF", "RBI" ,"R", "OUT"]
    let recordDetialArray = [["H", "2B", "3B", "HR"], ["BB", "HBP"], ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9"], ["K", "K"], ["SF", "SH"], ["1RBI", "2RBI", "3RBI", "4RBI"], ["(R)"], ["GO", "FO", "DP"]]
    
    var players = [Player]()
    var opponent = [Player]()
    var sendby: String?
    var recordPickerView: UIPickerView!
    var tempRecord: String = "H"
    var rowInRecordArray = Int()
    
    let popView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        recordPickerView = UIPickerView()
        recordPickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 12, height: 200)
        recordPickerView.showsSelectionIndicator = true
        recordPickerView.delegate = self
        recordPickerView.dataSource = self
        recordPickerView.backgroundColor = .cyan
        
        view.addSubview(popView)
        
        popView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        popView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        popView.addSubview(recordPickerView)
        popView.addSubview(addButton)
        
        addButton.bottomAnchor.constraint(equalTo: recordPickerView.bottomAnchor, constant: 12).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = GameTabBarController()
        controller.players = self.players
        controller.opponent = self.opponent
        controller.sendBy = self.sendby
        present(controller, animated: false, completion: nil)
    }
    
    func sendRecordBack() {
        let controller = GameTabBarController()
        if sendby == "Record" {
            self.players[rowInRecordArray].recordArray.append(tempRecord)
        } else {
            self.opponent[rowInRecordArray].recordArray.append(tempRecord)
        }
        controller.players = self.players
        controller.opponent = self.opponent
        controller.sendBy = self.sendby
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: false, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if component == 0 {            
            return recordtypeArray.count
        }
        return recordDetialArray[recordPickerView.selectedRow(inComponent: 0)].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return recordtypeArray[row]
        }
        return recordDetialArray[recordPickerView.selectedRow(inComponent: 0)][row]
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            recordPickerView.reloadComponent(1)
            tempRecord = recordDetialArray[row][0]
        } else if component == 1 {
            tempRecord = recordDetialArray[recordPickerView.selectedRow(inComponent: 0)][row]
        }
    }
    
}
