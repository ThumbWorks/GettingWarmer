//
//  DistancePicker.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/5/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import UIKit

class DistancePicker: NSObject {
    let options = Array(stride(from: 5, to: 101, by: 5))
    var optionChanged: ((Int) -> ())?
}

extension DistancePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
}

extension DistancePicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected \(options[row])")
        optionChanged?(options[row])
    }
}
