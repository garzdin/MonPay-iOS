//
//  CurrencyPickerViewController.swift
//  MonPay
//
//  Created by Teodor on 01/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol CurrencyPickerDelegate: class {
    func didSelectCurrency(index: Int, currency: String, sender: Any?)
}

class CurrencyPickerViewController: UIViewController, PickerViewDelegate, PickerViewDataSource {

    @IBOutlet var pickerView: PickerView!
    
    weak var delegate: CurrencyPickerDelegate?
    
    var segueSender: Any?
    
    let currencies = ["USD", "DKK", "BGN"]
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return currencies.count
    }
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 30.0
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        let item = currencies[index]
        return item
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        
        if highlighted {
            label.font = UIFont.systemFont(ofSize: 25.0)
            label.textColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
        } else {
            label.font = UIFont.systemFont(ofSize: 15.0)
            label.textColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 0.5)
        }
    }
    
    @IBAction func didPressChoose(_ sender: UIButton) {
        delegate?.didSelectCurrency(index: selectedRow, currency: currencies[selectedRow], sender: segueSender)
        self.dismiss(animated: true, completion: nil)
    }
}
