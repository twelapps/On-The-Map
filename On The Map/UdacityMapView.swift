//
//  UdacityMapView.swift
//  On The Map
//
//  Created by Twelker on Jun/4/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import MapKit

extension UdacityStudentMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        }
        view.pinColor = .Red // Red pin although it should be the default
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let url = view.annotation.subtitle
            if url != nil {
                if UdacityDBClient().verifyUrl(url) {
                    UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
                }
            }
        }
    }

extension MeOnMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.pinColor = .Green
            view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        }
        return view
    }
    
    // Handle tapping the call-out: in this app it should be redirection to an URL
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let url = view.annotation.subtitle
            if url != nil {
                if UdacityDBClient().verifyUrl(url) {
                    UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
                }
            }
            
    }

    
}

