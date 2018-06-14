//
//  ViewController.swift
//  Verizon5GApp2
//
//  Created by Pankaj Gupta on 06/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate, UIViewControllerTransitioningDelegate {
    
    let center = UNUserNotificationCenter.current()
    let applePayVC = ApplePayViewController(nibName: "ApplePayViewController", bundle: nil)
    private var headerDictionary = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        center.delegate = self
        applePayVC.transitioningDelegate = self
        addSettingScreen()
        let options: UNAuthorizationOptions = [.alert, .sound]
        createLocalNotification()
        center.requestAuthorization(options: options) { (granted, error) in
            if granted{
            }
        }
    }
    
    private func addSettingScreen() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ViewController.navigateToSettingScreen))
        navigationItem.rightBarButtonItem = barButton
    }
    
    func createLocalNotification(){
        
        // custom actions
        let plan1Action = UNNotificationAction(identifier: "Plan1", title: "30 mins - $9.99", options: [])
        let plan2Action = UNNotificationAction(identifier: "Plan2", title: "24 Hours - $0.10/Megabyte", options: [])
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: [.destructive])
        let category = UNNotificationCategory(identifier: "NotificationCategory", actions: [plan1Action,plan2Action,cancelAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        // notification content
        let content = UNMutableNotificationContent()
        content.body = "To run the game you need to upgrade your network speed. Please choose one option."
//        content.title = "some"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "NotificationCategory"
        
        // trigger with interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let notificationID = "LowLatencyNotification"
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // adding the request to notificaiton center
        center.add(request) { (error) in
            if let err = error{
                print(err)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
        switch response.actionIdentifier {
        case "Plan1":
            self.present(applePayVC, animated: true) {
            }
        case "Plan2":
            break
        case "Cancel":
            break
        default:
            break
        }
    }
    
    @objc private func navigateToSettingScreen() {
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        settingViewController.handleConfigurationDataDelegate = self
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let alert = UIAlertController(title: "Paid!", message: "You have paid $9.99 through your Apple Pay", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        let alert = AlertHelper()
//        alert.showAlert(fromController: self)
//        return nil
//    }
//}
//
//class AlertHelper {
//    func showAlert(fromController controller: UIViewController) {
//        let alert = UIAlertController(title: "Paid!", message: "You have paid $9.99 through your Apple Pay", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        controller.present(alert, animated: true, completion: nil)
//    }
}

extension ViewController: HandleConfigureData {
    func shareConfigurationData(configDictionary: [String : Any]) {
        self.headerDictionary = configDictionary
    }
}
