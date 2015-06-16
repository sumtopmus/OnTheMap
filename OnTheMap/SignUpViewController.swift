//
//  SignUpViewController
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 15.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIWebViewDelegate {

    // Magic Values
    private struct Defaults {
//        static let SignOutLink = "https://www.udacity.com/me"
//        static let EndOfSignOutLink = "https://www.udacity.com"

        static let SignUpLink = "https://www.udacity.com/account/auth#!/signup"
        static let EndOfSignUpLink = "https://www.udacity.com/me#!/"

        static let UnwindSegue = "Unwind From Done"
    }

    // MARK: Actions and Outlets

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
        }
    }

    // MARK: - Auxiliary Methods

//    private func signOut() {
//        openURL(Defaults.SignOutLink)
//    }

    private func signUp() {
        openURL(Defaults.SignUpLink)
    }

    private func openURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    // MARK: - UIWebView Delegate Methods

    func webViewDidFinishLoad(webView: UIWebView) {
        if let link = webView.request?.URL?.absoluteString {
//            if link != Defaults.SignUpLink {
//                cancelButton.enabled = false
//                doneButton.enabled = true
//            }

            if link == Defaults.EndOfSignUpLink {
                performSegueWithIdentifier(Defaults.UnwindSegue, sender: self)
            }
        }
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.enabled = false

        signUp()
    }
}