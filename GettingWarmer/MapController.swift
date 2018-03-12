//
//  MapController.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/6/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import MapKit

class MapController: NSObject {
    var cursorCircle: MKCircle?
    
    // This is for geofenced
    func addMonitoredRegion(mapView: MKMapView, circle: CLCircularRegion) {
        let circle = MKCircle(center: circle.center, radius: circle.radius)
        mapView.add(circle)
    }
    
    func updateCircle(mapView: MKMapView, radius: CLLocationDistance, location: CLLocationCoordinate2D) {
        if let cursorCircle = cursorCircle {
            mapView.remove(cursorCircle)
        }
        let circle = MKCircle(center: location, radius: radius)
        cursorCircle = circle
        print("radius is \(radius)")
        mapView.addOverlays([circle])
        mapView.setVisibleMapRect(circle.boundingMapRect, animated: true)
    }
    
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {        
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            var color: UIColor = .blue
            if circle == cursorCircle {
                color = .green
            }
            renderer.fillColor = color
            renderer.strokeColor = color
            renderer.alpha = 0.1
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
}
