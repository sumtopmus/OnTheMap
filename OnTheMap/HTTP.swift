//
//  HTTPConstants.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

struct HTTP {
    // HTTP methods
    struct Methods {
        static let GET = "GET"
        static let POST = "POST"
        static let DELETE = "DELETE"
    }

    // Header fields and values
    struct Header {
        static let AcceptField = "Accept"
        static let ContentField = "Content-Type"

        static let JSON = "application/json"
    }

    // Construct HTTP URL given method and parameters
    static func constructHTTPCall(baseURL: String, method: String, optionalSuffix: String? = nil, optionalParameters: [String : String]? = nil) -> NSURL {
        var urlString = baseURL + method
        if let suffix = optionalSuffix {
            urlString += suffix
        }
        if let parameters = optionalParameters {
            urlString += parameters.isEmpty ? "" : "?"

            var parametersSet = [String]()
            for (key, value) in parameters {
                if let escapeEncodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                    parametersSet.append(key + "=" + escapeEncodedValue)
                }
            }

            urlString += join("&", parametersSet)
        }

        return NSURL(string: urlString)!
    }
}

// Cookies
struct Cookies {
    static let XSRF = "XSRF-TOKEN"
}