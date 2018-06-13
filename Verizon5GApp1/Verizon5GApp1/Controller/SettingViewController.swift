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
        
        customerTextField.inputAccessoryView = toolBar
        serviceTextField.inputAccessoryView = toolBar
        locationTextField.inputAccessoryView = toolBar
    }
    
    /*private func validateTextFields() -> Bool {
        if eventDateTextField.text == "" || eventSourceTextField.text == "" || attr1TextField.text == "" || attr3TextField.text == "" || sliceTextField.text == "" || volumeTextField.text == "" {
            return false
        }
        return true
    }*/
    
    /*private func createTextFieldForLocation() {
        var dynamicLabel = UITextField(frame: CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
        dynamicLabel.frame =
            CGRectMake(50, 150, 200, 21)
        dynamicLabel.backgroundColor = UIColor.orangeColor()
        dynamicLabel.textColor = UIColor.blackColor()
        dynamicLabel.textAlignment = NSTextAlignment.Center
        dynamicLabel.text = "test label"
        self.view.addSubview(dynamicLabel)
    }*/
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    //MARK: Private variables
    private var headerDictionary = [String: Any]()
   
    //MARK: IBAction
   
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        headerDictionary["customer"] = customerTextField.text
        headerDictionary["service"] = serviceTextField.text
        headerDictionary["location"] = locationTextField.text
        
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
    
    @IBOutlet var customerTextField: UITextField!
    @IBOutlet var serviceTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
}
