//
//  MDBookingViewController.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

class MDBookingViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    let bookingURL = URL(string: "http://www.cathaycineplexes.com.sg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: bookingURL!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
