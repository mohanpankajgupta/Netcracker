//
//  ApplePayViewController.swift
//  Verizon5GApp2
//
//  Created by Pankaj Gupta on 12/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import UIKit
import LocalAuthentication


class ApplePayViewController: UIViewController {
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
        
    }

    private let networkCall = NetworkManager()
    var headerDictionary = [String: Any]()
    
    @IBAction func payTouchIDTouchUpInside(_ sender: UIButton) {
        authenticateUser()
    }
    
    private func callPostApi() {
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        self.networkCall.makePostRequest(urlString: postApiUrl
            , headerBody: self.headerDictionary, completion: { (result, response, error) in
                
                DispatchQueue.main.async {
                    
                    UIViewController.removeSpinner(spinner: sv)
                    if let _ = error {
                        self.displayAlert(title: "Activation Failure", message: "Unable to activate your service. Please give us a call or try again later.", callCancel: true)
                    }
                    
                    if let _ = result as? PostApiCall {
                        self.displayAlert(title: "Success", message: "Activation request successfully submitted.", callCancel: false)
                    }
                }
        })
    }
    
    private func displayAlert(title: String, message: String, callCancel: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if callCancel {
            alert.addAction(UIAlertAction(title: "Call", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        }
        self.present(alert, animated: true)
    }
    
    func authenticateUser()
    {
        let la = LAContext()
        var error : NSError?
        if la.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            la.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentiate to pay") { (granted, error) in
                if granted{
                    //                    print("granted")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Paid!", message: "You have paid $9.99 through your Apple Pay", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                            self.callPostApi()
//                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
