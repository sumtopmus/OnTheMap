//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

class UdacityAPI {

    // MARK: - Singleton Pattern

    static var client: UdacityAPI {
        get {
            return UdacityAPI.singleton
        }
    }

    private static let singleton: UdacityAPI = {
        println("Log: UdacityAPI singleton created.")
        return UdacityAPI()
    }()

    private init() {
        println("Log: UdacityAPI initialization.")
    }

    // MARK: - Properties

    var sessionID: String? {
        didSet {
            if sessionID != nil {
                println("Log: Session ID obtained.")
            } else {
                println("Log: Session ID set to nil.")
            }
        }
    }

    var user: User?

    // MARK: - Public API Access

    func signIn(#login: String, password: String, completion: ((success: Bool) -> Void)? = nil) {
        println("Log: In signIn method, preparing request...")

        let parameters = [
            JSONKeys.Username : login,
            JSONKeys.Password : password
        ]

        let url = HTTP.constructHTTPCall(Defaults.SecureBaseURL, method: Methods.Session)
        let request = createPOSTRequest(url, parameters: parameters)
        performRequest(request) { jsonData in
            println("Log: In signIn method, jsonData is obtained.")
            println("\(jsonData!)")

            if let sessionID = self.sessionIDFromSignInJSONResponse(jsonData) {
                self.sessionID = sessionID
//                getUserData(userID: <#String#>, completion: <#((success: Bool) -> Void)?##(success: Bool) -> Void#>)
                completion?(success: true)
            } else {
                completion?(success: false)
            }
        }
    }

    func signOut(completion: ((success: Bool) -> Void)? = nil) {
        println("Log: In signOut method, preparing request...")

        let url = HTTP.constructHTTPCall(Defaults.SecureBaseURL, method: Methods.Session)
        let request = createDELETERequest(url)

        println("TODO: Check if one needs to wait for a particular response to log out")

        performRequest(request, completion: nil)

        self.sessionID = nil

        completion?(success: true)
    }

    func getUserData(#userID: String, completion: ((success: Bool) -> Void)? = nil) {
        println("Log: In getUserData method, preparing request...")

        let url = HTTP.constructHTTPCall(Defaults.SecureBaseURL, method: Methods.Session, optionalSuffix: userID)
        let request = createGETRequest(url)
        performRequest(request) { jsonData in
            println("Log: In getUserData method, jsonData is obtained.")
            println("\(jsonData!)")

            println("TODO: Check obtained jsonData and send userData to completion")
            completion?(success: false)
        }
    }


    // MARK: - Internal API Access (HTTP Requests)

    // Create GET request
    private func createGETRequest(url: NSURL) -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: url)
    }

    // Create POST request
    private func createPOSTRequest(url: NSURL, parameters: [String:String]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTP.Methods.POST
        request.addValue(HTTP.Header.JSON, forHTTPHeaderField: HTTP.Header.AcceptField)
        request.addValue(HTTP.Header.JSON, forHTTPHeaderField: HTTP.Header.ContentField)
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(constructJSONObjectFromParameters(parameters), options: nil, error: nil)

        return request
    }

    // Create DELETE request
    private func createDELETERequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTP.Methods.DELETE

        var xsrfCookie: NSHTTPCookie?
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == Cookies.XSRF {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookieUnwrapped = xsrfCookie {
            request.addValue(xsrfCookieUnwrapped.value!, forHTTPHeaderField: HeaderFields.XSRF)
        }

        return request
    }

    // Perform request to HTTP server
    private func performRequest(request: NSMutableURLRequest, completion: ((parsedJSONData: AnyObject?) -> Void)?) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, requestError in
            if let error = requestError {
                println("ERROR: Could not complete the request \(error)")
            } else {
                let cleanedData = self.cleanData(data)
                let parsedData: AnyObject? = NSJSONSerialization.JSONObjectWithData(cleanedData, options: NSJSONReadingOptions.AllowFragments, error: nil)

                completion?(parsedJSONData: parsedData)
            }
        }

        task.resume()
    }

    // Construct JSON object for HTTP body given parameters
    private func constructJSONObjectFromParameters(parameters: [String:String]) -> AnyObject {
        var result: [String:AnyObject] = [JSONKeys.MainKey:parameters]

        return result
    }

    // Disregard characters added for security purposes
    private func cleanData(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(Defaults.NumberOfSecurityCharacters, data.length - Defaults.NumberOfSecurityCharacters))
    }

    // MARK: - From JSON to Structured PropertyList

    private func sessionIDFromSignInJSONResponse(jsonResponse: AnyObject?) -> String? {
        var result: String?
        if let jsonObject = jsonResponse as? [String:AnyObject],
            session = jsonObject[JSONKeys.Session] as? [String:AnyObject],
            sessionID = session[JSONKeys.SessionID] as? String {
            result = sessionID
        }
        return result
    }
}

// MARK: - Constants

extension UdacityAPI {
    // General magic values
    private struct Defaults {
        static let SecureBaseURL = "https://www.udacity.com/api/"
        static let NumberOfSecurityCharacters = 5
    }

    // API methods
    private struct Methods {
        static let Session = "session"
        static let Users = "users/"
    }

    // HTTP header fields
    private struct HeaderFields {
        static let XSRF = "X-XSRF-Token"
    }

    // JSON keys
    private struct JSONKeys {
        static let MainKey = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let Session = "session"
        static let SessionID = "id"
    }
}