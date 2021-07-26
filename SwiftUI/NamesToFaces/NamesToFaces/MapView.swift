//
//  MapView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/25/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var locationMet: CodableMKPointAnnotation
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotation(locationMet)
        mapView.centerCoordinate = locationMet.coordinate
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }
}
