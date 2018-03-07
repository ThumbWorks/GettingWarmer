//
//  MapController.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/6/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import MapKit

class MapController: NSObject {
    
    func updateCircle(mapView: MKMapView, radius: CLLocationDistance, location: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: location, radius: radius)
        print("radius is \(radius)")
        mapView.addOverlays([circle])
        mapView.setVisibleMapRect(circle.boundingMapRect, animated: true)
    }
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {        
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = .blue
            renderer.strokeColor = .blue
            renderer.alpha = 0.5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
