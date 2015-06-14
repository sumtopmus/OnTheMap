//
//  WebViewController
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 13.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK: - Actions and Outlets

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
        }
    }

    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!

    @IBAction func goBack(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction func goForward(sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    // MARK: - Properties

    var url = NSURL()

    // MARK: - UIWebView Delegate Methods

    func webViewDidFinishLoad(webView: UIWebView) {
        goBackButton.enabled = webView.canGoBack
        goForwardButton.enabled = webView.canGoForward
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(NSURLRequest(URL: url))
    }
}