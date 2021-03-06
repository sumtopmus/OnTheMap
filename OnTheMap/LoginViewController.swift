//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 11.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

@IBDesignable
class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    // Magic values
    private struct Defaults {
        // Selectors
        static let KeyboardWillShowSelector: Selector = "keyboardWillShow:"
        static let KeyboardWillHideSelector: Selector = "keyboardWillHide:"
        static let OnTapSelector: Selector = "onSingleTap:"
        // Segues
        static let SignInSegue = "Sign In"
        static let SignUpSegue = "Sign Up"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var debugLabel: UILabel!

    @IBAction func signIn(sender: UIButton) {
        signIn()
    }

    func onSingleTap(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // MARK: - Fields

    private var layoutAdjustedToKeyboard = false
    private var lastViewOffset: CGFloat = 0.0
    private var lastLogoOffset: CGFloat = 0.0

    private var logoTopConstraint: NSLayoutConstraint!
    private var logoBottomConstraint: NSLayoutConstraint!

    private var tapGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            tapGestureRecognizer.delegate = self
        }
    }

    // MARK: - Auxiliary Methods

    private func signIn() {
        self.view.endEditing(true)
        clearDebugLabel()
        if checkValidness(loginField: loginField, passwordField: passwordField) {
            UdacityAPI.client.signIn(login: loginField.text, password: passwordField.text) { success in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.performSegueWithIdentifier(Defaults.SignInSegue, sender: self)
                    } else {
                        self.passwordField.text = ""
                        self.setAndDissolveDebugLabel(View.InvalidCredentials)
                    }
                }
            }
        } else {
            setAndDissolveDebugLabel(View.InvalidTextFields)
        }
    }

    private func checkValidness(#loginField: UITextField, passwordField: UITextField) -> Bool {
        println("TODO: Check validity of login and rassword")
        return true
    }

    private func openURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    // MARK: - Layout

    private func setupUI() {
        setupMainView()
        setupLogoView()
        setupIntroLabel()
        setupLoginTextField()
        setupPasswordTextField()
        setupSignInButton()
        setupSignUpButton()
        setupDebugLabel()

        UITextField.appearance().tintColor = View.TextColor
    }

    private func setupMainView() {
        self.view.contentMode = UIViewContentMode.Redraw
        addGradientToView(self.view)
    }

    private func addGradientToView(view: UIView) {
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [View.BackgroundGradientTopColor, View.BackgroundGradientBottomColor]
        backgroundGradient.locations = [View.GradientTopLocation, View.GradientBottomLocation]
        backgroundGradient.frame = view.frame

        view.backgroundColor = UIColor.clearColor()
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }

    private func setupLogoView() {
        logoTopConstraint = NSLayoutConstraint(item: logoView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: View.ImageSpacing)
        logoBottomConstraint = NSLayoutConstraint(item: loginLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: logoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:View.ImageSpacing)
        self.view.addConstraints([logoTopConstraint, logoBottomConstraint])

        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        logoView.image = UIImage(named: View.UdacityLogoImage)
    }

    private func setupIntroLabel() {
        loginLabel.font = View.StandardFont
        loginLabel.textColor = View.TextColor
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.text = View.IntroLabel
    }

    private func setupLoginTextField() {
        setupTextField(loginField)
        loginField.keyboardType = UIKeyboardType.EmailAddress
        loginField.returnKeyType = UIReturnKeyType.Next
        loginField.attributedPlaceholder = NSAttributedString(string: View.LoginPlaceholder, attributes: [NSForegroundColorAttributeName : View.TextColor])

        let textFieldHeightConstraint = NSLayoutConstraint(item: loginField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: View.TextFieldHeight)
        loginField.addConstraint(textFieldHeightConstraint)

    }

    private func setupPasswordTextField() {
        setupTextField(passwordField)
        passwordField.secureTextEntry = true
        passwordField.attributedPlaceholder = NSAttributedString(string: View.PasswordPlaceholder, attributes: [NSForegroundColorAttributeName : View.TextColor])
    }

    private func setupTextField(textField: UITextField) {
        textField.backgroundColor = View.TextFieldBackgroundColor
        textField.borderStyle = UITextBorderStyle.None

        let paddingView = UIView(frame: CGRectMake(0.0, 0.0, View.TextFieldLeftMargin, 0.0))
        textField.leftView = paddingView
        textField.leftViewMode = .Always

        textField.font = View.StandardFont
        textField.textColor = View.SignInButtonBackgroundColor

        textField.delegate = self
    }

    private func setupSignInButton() {
        signInButton.backgroundColor = View.SignInButtonBackgroundColor
        signInButton.titleLabel?.font = View.StandardFont
        signInButton.setTitleColor(View.TextColor, forState: .Normal)
        signInButton.setTitle(View.SignInLabel, forState: UIControlState.Normal)

    }

    private func setupSignUpButton() {
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.titleLabel?.font = View.StandardFont
        signUpButton.setTitleColor(View.TextColor, forState: .Normal)
        signUpButton.setTitle(View.SignUpLabel, forState: UIControlState.Normal)
    }

    private func clearTextFields() {
        loginField.text = ""
        passwordField.text = ""
    }

    // Debug label

    private func setupDebugLabel() {
        //        debugLabel.frame.size.height = 44.0
        debugLabel.font = View.StandardFont
        debugLabel.textColor = View.TextColor
        debugLabel.textAlignment = NSTextAlignment.Center
        clearDebugLabel()
    }

    private func setAndDissolveDebugLabel(text: String) {
        debugLabel.alpha = View.DebugLabelMaxAlpha
        debugLabel.text = text

        UIView.animateWithDuration(View.DebugLabelAnimationDuration) {
            self.debugLabel.alpha = 0.0
        }
    }

    private func clearDebugLabel() {
        debugLabel.text = ""
        debugLabel.alpha = View.DebugLabelMaxAlpha
    }

    // MARK: - Keyboard-dependent Layout

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == loginField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signIn()
        }

        return false
    }

    func keyboardWillShow(notification: NSNotification) {
        clearDebugLabel()
        if !layoutAdjustedToKeyboard {
            lastViewOffset = getMainViewShift(getKeyboardHeight(notification))
            lastLogoOffset = logoView.frame.maxY - lastViewOffset
            self.view.frame.origin.y -= lastViewOffset
            logoView.alpha = 0.0
            layoutAdjustedToKeyboard = true
        }
        addTapGestureRecognizer()
    }

    func keyboardWillHide(notification: NSNotification) {
        if layoutAdjustedToKeyboard {
            self.view.frame.origin.y += lastViewOffset
            logoView.alpha = 1.0
            layoutAdjustedToKeyboard = false
        }
        removeTapGestureRecognizer()
    }

    private func getMainViewShift(keyboardHeight: CGFloat) -> CGFloat {
        return min(loginLabel.frame.minY - View.TopSpace, View.KeyboardMinimalHeight)
    }

    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        return keyboardSize?.CGRectValue().height ?? 0
    }

    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Defaults.KeyboardWillShowSelector, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Defaults.KeyboardWillHideSelector, name: UIKeyboardWillHideNotification, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    private func addTapGestureRecognizer() {
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func removeTapGestureRecognizer() {
        self.view.removeGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Defaults.OnTapSelector)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        clearTextFields()

        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Navigation

    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
        clearTextFields()
    }
}