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
        static let AddUserLocationSegue = "Add User Location"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        updateStudentLocations()
    }

    @IBAction func userLocationAdded(sender: UIStoryboardSegue)
    {
        let sourceViewController = sender.sourceViewController as! SubmitLocationViewController

        let userLocation = StudentLocation(user: UdacityAPI.client.user!)
        userLocation.latitude = sourceViewController.coordinate.latitude
        userLocation.latitude = sourceViewController.coordinate.longitude
        userLocation.mediaURL = sourceViewController.userMediaLinkField.text

        ParseAPI.client.postUserLocation(userLocation) { success in
            if success {
                self.mapView.addAnnotation(userLocation)
            }
        }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Defaults.AddUserLocationSegue {
            let navVC = segue.destinationViewController as! UINavigationController
            let destination = navVC.visibleViewController as! AddLocationViewController
            destination.region = mapView.region
        }
    }
}