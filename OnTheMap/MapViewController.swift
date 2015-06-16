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

    // MARK: - Auxiliary methods

    private func updateStudentLocations() {
        mapView.removeAnnotations(mapView.annotations)
        ParseAPI.client.getStudentLocations(putLocationsOnMap)
    }

    private func putLocationsOnMap(locations: [StudentLocation]) {
        if locations.count > 0 {
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(locations)
            }
        }
    }

    private func openURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
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
        if let urlString = view.annotation.subtitle {
            openURL(urlString)
        }
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStudentLocations()
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Defaults.AddUserLocationSegue {
            let navVC = segue.destinationViewController as! UINavigationController
            let destination = navVC.visibleViewController as! AddLocationViewController
            destination.region = mapView.region
        }
    }

    @IBAction func userLocationAdded(segue: UIStoryboardSegue)
    {
        let sourceViewController = segue.sourceViewController as! SubmitLocationViewController

        let userLocation = StudentLocation(user: UdacityAPI.client.user!)
        userLocation.latitude = sourceViewController.coordinate.latitude
        userLocation.longitude = sourceViewController.coordinate.longitude
        userLocation.mapString = sourceViewController.userLocation
        userLocation.mediaURL = sourceViewController.userMediaLinkField.text

        ParseAPI.client.postUserLocation(userLocation) { success in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotation(userLocation)
                    self.mapView.showAnnotations([userLocation], animated: true)
                }
            }
        }
    }
}