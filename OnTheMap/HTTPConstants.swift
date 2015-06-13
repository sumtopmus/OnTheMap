//
//  HTTPConstants.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

// HTTP methods
struct HTTPMethods {
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
}

// Header fields and values
struct HTTPHeader {
    static let JSON = "application/json"

    static let Accept = "Accept"
    static let Content = "Content-Type"
    static let XSRF = "X-XSRF-Token"
}

// Cookies
struct Cookies {
    static let XSRF = "XSRF-TOKEN"
}