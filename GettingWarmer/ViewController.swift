//
//  ViewController.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/5/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import UIKit
import MapKit
import HomeController

protocol GeofenceThresholdListener {
    func enteredGeofence()
}

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initiateLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distancePickerView: UIPickerView!

    // Helper objects
    let distancePicker = DistancePicker()
    let locationManager = LocationManager()
    let mapController = MapController()
    let homeController = HomeController()

    // actual data
    var location: CLLocation?
    var radius: CLLocationDistance = CLLocationDistance(100000)
    
    func successfulLocationAuth() {
        locationManager.startUpdatingLocation()
    }

    override func viewDidLoad() {
        distancePickerView.dataSource = distancePicker
        distancePickerView.delegate = distancePicker
        locationManager.delegate = locationManager
        mapView.delegate = mapController
        
        for region in locationManager.monitoredRegions {
            print("this is one of the regions monitored")
            if let region = region as? CLCircularRegion {
                print("it is a circler")
                mapController.addMonitoredRegion(mapView: mapView, circle: region)
//                radius = region.radius
//                location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            }
        }
        
        locationManager.authBlock = { (success, string) in
            print("Location Auth change \(String(describing: string))")
            if success {
                self.successfulLocationAuth()
            }
        }
        
        locationManager.locationUpdate = { (location) in
            self.locationManager.stopUpdatingLocation()
            print("location updated \(location.coordinate)")
            self.location = location
            self.mapController.updateCircle(mapView: self.mapView, radius: self.radius, location: location.coordinate)
        }
        
        distancePicker.optionChanged = { (radius) in
            print("view controller got a change \(radius)")
            self.radius = CLLocationDistance(radius * 1000)
            guard let location = self.location else {return}
            self.mapController.updateCircle(mapView: self.mapView, radius: self.radius, location: location.coordinate)
        }
        
        switch LocationManager.authorizationStatus() {
            
        case .notDetermined:
            break
        case .restricted:
            print("restricted. Probably can't use")
        case .denied:
            print("You can go to settings to enable location")
        case .authorizedAlways:
            successfulLocationAuth()
        case .authorizedWhenInUse:
            print("You can go to settings to increase location settings permissions")
        }
    }
}

extension ViewController {
    
    @IBAction func doublePressedMap(sender: UILongPressGestureRecognizer) {
        print("double tap")

        let coordinate = mapView.centerCoordinate
        let newLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        location = newLocation
        radius =
            mapView.region.span.latitudeDelta * 111000 / 2
        mapController.updateCircle(mapView: mapView, radius: radius, location: newLocation.coordinate)
    }
    
    @IBAction func initiateLocationButton(initiateButton: UIButton) {
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func initiateHomeKit(_ sender: Any) {
        homeController.homekitSetup()
        print("home \(homeController.home)")
    }
    
    @IBAction func printTemperature(_ sender: Any) {
        
        guard let number = homeController.home.thermostats.first?.temperature() else {
            print("No thermostat temperature available")
            return
        }
        let alert = UIAlertController(title: "Current Temperature", message: "The current temperature is \(number)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    @IBAction func authorizeNotificaitons(_ sender: Any) {
        NotificationManager().authorizeNotifications()
    }
    
    @IBAction func testNotification(_ sender: Any) {
        for region in locationManager.monitoredRegions{
            print("this is a region we are monitoring: \(region.identifier), \(region)")
        }
        NotificationManager().triggerNotification(seconds: TimeInterval(5), body: "Testing notification")
    }
    
    @IBAction func setGeofence(_ sender: Any) {
        print("Set the Geofence")
        guard let location = location else {return}
        
        let circle = CLCircularRegion(center: location.coordinate,
                                      radius: radius,
                                      identifier: Date().description)
        mapController.addMonitoredRegion(mapView: mapView, circle: circle)
        
        // Now monitor that region
        let region = CLCircularRegion(center: location.coordinate, radius: radius, identifier: "homeRegionIdentifier")
        locationManager.startMonitoring(for: region)
    }
}
