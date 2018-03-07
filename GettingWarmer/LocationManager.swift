//
//  LocationManager.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/6/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import MapKit

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    var authBlock: ((Bool, String?) -> ())?
    var locationUpdate: ((CLLocation) -> ())?
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered a region")
        NotificationManager().triggerNotification(seconds: TimeInterval(5), body: "Entered a region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region")
        NotificationManager().triggerNotification(seconds: TimeInterval(5), body: "Exited a region")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            authBlock?(false, "Not determined")
            
        case .restricted:
            authBlock?(false, "Not enough perms maybe")
            
        case .denied:
            authBlock?(false, "Denied")
            
        case .authorizedAlways:
            authBlock?(true, nil)
            
        case .authorizedWhenInUse:
            authBlock?(false, "Not enough perms")
            
        }
        print("did change authorization")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationUpdate?(location)
        }
    }
    
}
