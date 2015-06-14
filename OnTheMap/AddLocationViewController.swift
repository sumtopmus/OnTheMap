//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 14.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    // Magic Values
    private struct Defaults {
        // Segues
        static let FindOnTheMapSegue = "Find On The Map"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.delegate = self
        }
    }

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSingleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // MARK: - Properties

    var region: MKCoordinateRegion!

    // MARK: - Layout

    private func setupUI() {
        topView.backgroundColor = View.AddLocationBackgroundGrayColor

        topLabel.textAlignment = NSTextAlignment.Center
        topLabel.font = View.AddLocationFont
        topLabel.textColor = View.AddLocationGrayColor
        topLabel.text = View.AddLocationTopLabelText

        mediumLabel.textAlignment = NSTextAlignment.Center
        mediumLabel.font = View.AddLocationBoldFont
        mediumLabel.textColor = View.AddLocationGrayColor
        mediumLabel.text = View.AddLocationMediumLabelText

        bottomLabel.textAlignment = NSTextAlignment.Center
        bottomLabel.font = View.AddLocationFont
        bottomLabel.textColor = View.AddLocationGrayColor
        bottomLabel.text = View.AddLocationBottomLabelText

        middleView.backgroundColor = View.AddLocationBlueColor

        locationTextField.textAlignment = NSTextAlignment.Center
        locationTextField.font = View.AddLocationFont!.fontWithSize(View.AddLocationTextFieldSize)
        locationTextField.attributedPlaceholder = NSAttributedString(string: View.AddLocationHintText, attributes: [NSForegroundColorAttributeName : View.AddLocationLightGrayColor])
        locationTextField.textColor = View.AddLocationLightGrayColor
        locationTextField.text = ""
        locationTextField.borderStyle = UITextBorderStyle.None

        bottomView.backgroundColor = View.AddLocationBackgroundGrayColor

        findOnTheMapButton.titleLabel?.font = View.AddLocationFont!.fontWithSize(View.AddLocationTextFieldSize)
        findOnTheMapButton.setTitleColor(View.AddLocationBlueColor, forState: .Normal)
        findOnTheMapButton.setTitle(View.AddLocationButtonText, forState: UIControlState.Normal)
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
        textField.attributedPlaceholder = NSAttributedString(string: View.AddLocationHintText, attributes: [NSForegroundColorAttributeName : View.TextColor])
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Defaults.FindOnTheMapSegue {
            let destination = segue.destinationViewController as! SubmitLocationViewController
            destination.region = region
            destination.userLocation = locationTextField.text!
        }
    }
}