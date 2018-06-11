//
//  SettingViewController.swift
//  Verizon5GApp1
//
//  Created by Smita Tamboli on 07/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        eventDateTextField.text = Utility.date(from: Date())
        createToolBar()
    }
    
    //MARK: Public variable
    var handleConfigurationDataDelegate: HandleConfigureData? = nil
    
    //MARK: Private methods
    private func createToolBar() {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SettingViewController.dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        eventSourceTextField.inputAccessoryView = toolBar
        eventDateTextField.inputAccessoryView = toolBar
        attr1TextField.inputAccessoryView = toolBar
        attr3TextField.inputAccessoryView = toolBar
        sliceTextField.inputAccessoryView = toolBar
        volumeTextField.inputAccessoryView = toolBar
    }
    
    /*private func validateTextFields() -> Bool {
        if eventDateTextField.text == "" || eventSourceTextField.text == "" || attr1TextField.text == "" || attr3TextField.text == "" || sliceTextField.text == "" || volumeTextField.text == "" {
            return false
        }
        return true
    }*/
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged(sender:UIDatePicker) {
        eventDateTextField.text = Utility.date(from: sender.date)
    }
    
    //MARK: Private variables
    private var headerDictionary = [String: Any]()
   
    //MARK: IBAction
    @IBAction func eventDateTextField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.minimumDate = Date()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SettingViewController.datePickerValueChanged), for: .valueChanged)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        headerDictionary["event_source"] = eventSourceTextField.text ?? "99910001000"
        headerDictionary["event_date"] = eventDateTextField.text
        headerDictionary["attr1"] = attr1TextField.text ?? "02453"
        headerDictionary["attr3"] = attr3TextField.text ?? "NORMALQOS"
        headerDictionary["Slice"] = sliceTextField.text ?? "regular"
        headerDictionary["Volume"] = volumeTextField.text ?? "1500"
        
        handleConfigurationDataDelegate?.shareConfigurationData(configDictionary: headerDictionary)
        
        let alert = UIAlertController(title: "Alert!", message: "All configuration saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
        
        /*if validateTextFields() {
            
            headerDictionary["event_source"] = eventSourceTextField.text
            headerDictionary["event_date"] = eventDateTextField.text
            headerDictionary["attr1"] = attr1TextField.text
            headerDictionary["attr3"] = attr3TextField.text
            headerDictionary["Slice"] = sliceTextField.text
            headerDictionary["Volume"] = volumeTextField.text
            
            handleConfigurationDataDelegate?.shareConfigurationData(configDictionary: headerDictionary)
            
        } else {
            let alert = UIAlertController(title: "Alert!", message: "All fields are required.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }*/
        
    }
    
    //MARK: IBOutlets
    
    @IBOutlet var eventDateTextField: UITextField!
    @IBOutlet var eventSourceTextField: UITextField!
    @IBOutlet var attr1TextField: UITextField!
    @IBOutlet var attr3TextField: UITextField!
    @IBOutlet var sliceTextField: UITextField!
    @IBOutlet var volumeTextField: UITextField!
}
