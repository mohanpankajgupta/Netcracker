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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: IBAction
    
    @IBAction func selectDateButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
    }
    
    //MARK: IBOutlets
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var eventSourceTextField: UITextField!
    @IBOutlet var attr1TextField: UITextField!
    @IBOutlet var attr3TextField: UITextField!
    @IBOutlet var sliceTextField: UITextField!
    @IBOutlet var volumeTextField: UITextField!
}
