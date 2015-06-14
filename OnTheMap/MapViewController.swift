//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 11.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // Magic Values
    private struct Defaults {
        static let AnnotationViewReuseIdentifier = "Standard Pin Annotation View"
        static let ShowWebViewSegue = "Show Web View"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    @IBAction func addUserLocation(sender: UIBarButtonItem) {
    }

    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        updateStudentLocations()
    }

    // MARK: - Auxiliary methods

    private func updateStudentLocations() {
        mapView.removeAnnotations(mapView.annotations)
        ParseAPI.client.getStudentLocations(putLocationsOnMap)
    }

    private func putLocationsOnMap(locations: [StudentLocation]?) {
        if let studentLocations = locations {
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(studentLocations)
            }
        }
    }

    // MARK: - MKMapView Delegate Methods

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(Defaults.AnnotationViewReuseIdentifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Defaults.AnnotationViewReuseIdentifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        } else {
            annotationView.annotation = annotation
        }

        return annotationView
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let urlString = view.annotation.subtitle, url = NSURL(string: urlString) {
            // TODO: Open link in Safari
        }
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStudentLocations()
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    }
}