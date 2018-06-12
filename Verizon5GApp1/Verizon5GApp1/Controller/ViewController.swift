//
//  ViewController.swift
//  Verizon5GApp1
//
//  Created by Pankaj Gupta on 06/06/18.
//  Copyright © 2018 netcracker. All rights reserved.
//

import UIKit
import MapKit

let locationManager = CLLocationManager()

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getRestrictedAreaFromPlist()
        setupMap()
        setupLocationSearchTable()
        configureSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private methods
    private func setupMap() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupLocationSearchTable() {
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.mapView = mapView
    }
    
    private func configureSearchBar() {
        let searchBar = resultSearchController?.searchBar
        
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ViewController.navigateToSettingScreen))
        navigationItem.rightBarButtonItem = barButton
        
        definesPresentationContext = true
    }
    
    @objc private func navigateToSettingScreen() {
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        settingViewController.handleConfigurationDataDelegate = self
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    private func displayActionsheet() {
        let actionSheet = UIAlertController(title: "Select service", message: "", preferredStyle: .actionSheet)
        
        let service1 = UIAlertAction(title: "Service1", style: .default, handler: { (action) -> Void in
            self.displayAlert()
        })
        
        let service2 = UIAlertAction(title: "service2", style: .default) { (alert) -> Void in
            self.displayAlert()
        }
        
        let service3 = UIAlertAction(title: "service3", style: .default) { (alert) -> Void in
            self.displayAlert()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
            
        }
        
        actionSheet.addAction(service1)
        actionSheet.addAction(service2)
        actionSheet.addAction(service3)
        actionSheet.addAction(cancelButton)
        
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func getCurrentLocationDetails(currentLocation: CLLocation) -> CLPlacemark? {
        let geocoder = CLGeocoder()
        
        var availablePlacemark: CLPlacemark?
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let placemark = placemarks?.first {
                availablePlacemark = placemark
            }
        }
        
        return availablePlacemark
    }
    
    private func getRestrictedAreaFromPlist() {
        restricteAreaArray.removeAll()
        
        if let path = Bundle.main.path(forResource: "LocationRegions", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot, let restricted = dict["Brooklyn"] as? NSArray {
                
                let restrictedLocation = RestrictedLocation()
                
                if let radiousString = restricted[0] as? String {
                    restrictedLocation.radious = CLLocationDistance(radiousString)
                }
                
                if let latString = restricted[1] as? String {
                    restrictedLocation.lat = CLLocationDegrees(latString)
                }
                
                if let longString = restricted[2] as? String {
                    restrictedLocation.long = CLLocationDegrees(longString)
                }
                
                restricteAreaArray.append(restrictedLocation)
                
            }
        }
    }
    
    private func checkForRestrictedLocation() -> Bool {
        
        for restrictedArea in restricteAreaArray {
            
            if let restrictedAreaLat = restrictedArea.lat, let restrictedAreaLong = restrictedArea.long, let restrictedAreaRadious = restrictedArea.radious, let selectedLat = selectedLocation?.latitude, let selectedLong = selectedLocation?.longitude {
                let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: restrictedAreaLat, longitude: restrictedAreaLong), radius: restrictedAreaRadious, identifier: "Region")
                
                if circularRegion.contains(CLLocationCoordinate2D(latitude: selectedLat
                    , longitude: selectedLong)) {
                    return true
                }
            }
            
        }
        
        return false
        
    }
    
    private func displayAlert() {
        
        if checkForRestrictedLocation() {
            let alert = UIAlertController(title: "Poor Coverage", message: "We can not guarantee requested quality of service at this location.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Activate", style: .default, handler: {action in
                //call post service
                self.callPostApi()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            callPostApi()
        }
        
    }
    
    private func callPostApi() {
        
        let sv = UIViewController.displaySpinner(onView: self.mapView)
        
        self.networkCall.makePostRequest(urlString: postApiUrl
            , headerBody: self.headerDictionary, completion: { (result, response, error) in
                
                DispatchQueue.main.async {
                    
                    UIViewController.removeSpinner(spinner: sv)
                    if let error = error {
                        self.displayAlert(title: "Alert!", message: error.localizedDescription)
                    }
                    
                    if let result = result as? PostApiCall, let message = result.message {
                        self.displayAlert(title: "Alert!", message: message)
                    }
                }
        })
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //MARK: Private variables
    private var resultSearchController:UISearchController? = nil
    private var selectedPin:MKPlacemark? = nil
    private let locationManager = CLLocationManager()
    private let annotation = MKPointAnnotation()
    private var restricteAreaArray = [RestrictedLocation]()
    private var selectedLocation: CLLocationCoordinate2D?
    private let networkCall = NetworkManager()
    private var headerDictionary = [String: Any]()
    
    @IBAction func openSettingAppButtonAction(_ sender: Any) {
        
        if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(appSettings as URL)
                }
            }
        }
    }
    //MARK: IBOutlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var networkStatusButton: UIButton!
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        displayActionsheet()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            networkStatusButton.isHidden = false
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        networkStatusButton.isHidden = true
        manager.stopUpdatingLocation()
        
        if let location = locations.first {
            selectedLocation = location.coordinate
            if let placemark = getCurrentLocationDetails(currentLocation: location) {
                annotation.title = placemark.name
                if let city = placemark.locality,
                    let state = placemark.administrativeArea {
                    annotation.subtitle = "\(city) \(state)"
                }
            }
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension ViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        selectedLocation = placemark.coordinate
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension ViewController: HandleConfigureData {
    func shareConfigurationData(configDictionary: [String : Any]) {
        self.headerDictionary = configDictionary
    }
}

