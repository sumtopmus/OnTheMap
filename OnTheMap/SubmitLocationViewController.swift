//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 14.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    // Magic Values
    private struct Defaults {
        // Segues
        static let UnwindSegue = "Unwind"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userMediaLinkField: UITextField! {
        didSet {
            userMediaLinkField.delegate = self
        }
    }

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBAction func onSingleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // MARK: - Properties

    var region: MKCoordinateRegion!
    var userLocation: String!

    var coordinate: CLLocationCoordinate2D!

    // MARK: - Auxiliary Methods

    private func addAnnotationsFromResponse(response: MKLocalSearchResponse) {
        let items = response.mapItems as! [MKMapItem]
        mapView.addAnnotations(items.map { $0.placemark as MKAnnotation })
        mapView.showAnnotations(mapView.annotations, animated: false)
        if mapView.annotations.count == 1 {
            let annotation = mapView.annotations.first as! MKAnnotation
            coordinate = annotation.coordinate
            enableDoneButtonIfDataIsSet()
        }
    }

    private func enableDoneButtonIfDataIsSet() {
        if coordinate != nil {
            doneButton.enabled = true
        }
    }

    // MARK: - UITextField Delegate Methods

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textAlignment = NSTextAlignment.Left
        textField.placeholder = ""
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.textAlignment = NSTextAlignment.Center
        textField.attributedPlaceholder = NSAttributedString(string: View.AddLinkHintText, attributes: [NSForegroundColorAttributeName : View.TextColor])
        enableDoneButtonIfDataIsSet()
    }

    // MARK: - MKMapView Delegate Methods

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        coordinate = view.annotation.coordinate
        enableDoneButtonIfDataIsSet()
    }

    // MARK: - Layout

    private func setupUI() {
        topView.backgroundColor = View.AddLocationBlueColor

        userMediaLinkField.textAlignment = NSTextAlignment.Center
        userMediaLinkField.font = View.AddLocationFont!.fontWithSize(View.AddLocationTextFieldSize)
        userMediaLinkField.attributedPlaceholder = NSAttributedString(string: View.AddLinkHintText, attributes: [NSForegroundColorAttributeName : View.AddLocationLightGrayColor])
        userMediaLinkField.textColor = View.AddLocationLightGrayColor
        userMediaLinkField.text = ""
        userMediaLinkField.borderStyle = UITextBorderStyle.None
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        enableDoneButtonIfDataIsSet()

        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = userLocation
        request.region = region

        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, error in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.addAnnotationsFromResponse(response)
                }
            }
        }
    }
}