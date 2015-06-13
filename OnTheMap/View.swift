//
//  View.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation
import UIKit

struct View {

    // UI elements: Fonts
    static let FontName = "AvenirNext-Medium"
    static let FontSize: CGFloat = 17.0
    static let Font = UIFont(name: FontName, size: FontSize)

    // UI elements: Colors
    static let TextColor = UIColor.whiteColor()

    static let TextFieldBackgroundColor = UIColor(red: 190.0 / 255, green: 150.0 / 255, blue: 120.0 / 255, alpha: 1.0)

    static let SignInButtonBackgroundColor = UIColor(red: 175.0 / 255, green: 50.0 / 255, blue: 35.0 / 255, alpha: 1.0)

    static let BackgroundGradientTopColor = UIColor(red: 180.0 / 255, green: 102.0 / 255, blue: 5.0 / 255, alpha: 1.0).CGColor
    static let BackgroundGradientBottomColor = UIColor(red: 199.0 / 255, green: 87.0 / 255, blue: 41.0 / 255, alpha: 1.0).CGColor

    // UI elements: Gradient location
    static let GradientTopLocation: CGFloat = 0.0
    static let GradientBottomLocation: CGFloat = 1.0

    // UI elements: Images
    static let UdacityLogoImage = "udacity-logo"

    // UI elements: Text
    static let IntroLabel = "Login to Udacity"
    static let LoginPlaceholder = "Email"
    static let PasswordPlaceholder = "Password"
    static let SignInLabel = "Login"
    static let SignUpLabel = "Don't have an account? Sign Up"

    // TODO: Not used, remove
    // UI elements: Tags
//    static let LoginTextFieldTag = 0
//    static let PasswordTextFieldTag = 1

    // UI elemts: Custom values
    static let TextFieldHeight: CGFloat = 44.0
    static let TextFieldLeftMargin: CGFloat = 13.0
    static let TopSpace: CGFloat = 20.0
    static let ImageSpacing: CGFloat = 2 * TopSpace
    // TODO: Need to be checked
    static let KeyboardMinimalHeight: CGFloat = 200.0

    // Debug text
    static let InvalidLoginOrPasswordFields = "Login and password should be nonempty"

}