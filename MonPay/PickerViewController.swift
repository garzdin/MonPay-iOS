//
//  PickerViewController.swift
//  MonPay
//
//  Created by Teodor on 01/02/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit

protocol CurrencyPickerDelegate: class {
    func didSelectCurrency(index: Int, currency: String, sender: Any?)
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIPickerView!
    
    weak var delegate: CurrencyPickerDelegate?
    
    var segueSender: Any?
    
    var data: [String]?
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: component).width, height: pickerView.rowSize(forComponent: component).height)
        let label = UILabel(frame: frame)
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.textColor = UIColor(red: 72/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1.0)
        label.textAlignment = NSTextAlignment.center
        label.text = self.data?[row]
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    @IBAction func didPressChoose(_ sender: UIButton) {
        delegate?.didSelectCurrency(index: selectedRow, currency: data![selectedRow], sender: segueSender)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
