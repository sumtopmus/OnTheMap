//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

class ParseAPI {

    // MARK: - Singleton Pattern

    static var client: ParseAPI {
        get {
            return ParseAPI.singleton
        }
    }

    private static let singleton: ParseAPI = {
        println("Log: ParseAPI singleton created")
        return ParseAPI()
        }()

    private init() {
        println("Log: ParseAPI initialization")
    }

    // MARK: - Public API Access

    func getStudentLocations(completion: ((locations: [StudentLocation]?) -> Void)?) {
        let parameters = [Parameters.Limit : "\(Defaults.MaximumStudentsNumberToFetch)"]

        let url = HTTP.constructHTTPCall(Defaults.SecureBaseURL, method: Methods.StudentLocation, optionalParameters: parameters)
        let request = createGETRequest(url)
        performRequest(request) { jsonData in
            println("Log: In getStudentLocations method, jsonData is obtained.")
            println("\(jsonData!)")

            let jsonDictionarys = self.studentLocationsFromJSONResponse(jsonData)
            completion?(locations: jsonDictionarys)
        }
    }

    func postUserLocation(location: StudentLocation, completion: ((success: Bool) -> Void)?) {
        let url = HTTP.constructHTTPCall(Defaults.SecureBaseURL, method: Methods.StudentLocation)
        let request = createPOSTRequest(url, parameters: location.toPOSTJSONDictionary())

        performRequest(request) { jsonData in
            println("Log: In postUserLocation method, jsonData is obtained.")
            println("\(jsonData!)")

            completion?(success: true)
        }
    }

    // MARK: - Internal API Access (HTTP Requests)

    // Create GET request
    private func createGETRequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        addAppIDAndAPIKeyToRequest(request)

        return request
    }

    // Create POST request
    private func createPOSTRequest(url: NSURL, parameters: [String:AnyObject]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        addAppIDAndAPIKeyToRequest(request)
        request.HTTPMethod = HTTP.Methods.POST
        request.addValue(HTTP.Header.JSON, forHTTPHeaderField: HTTP.Header.ContentField)
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(constructJSONObjectFromParameters(parameters), options: nil, error: nil)

        return request
    }

    // Create DELETE request
    private func createDELETERequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        addAppIDAndAPIKeyToRequest(request)
        request.HTTPMethod = HTTP.Methods.DELETE

        // TODO: implement DELETE request construction

        return request
    }

    // Perform request to HTTP server
    private func performRequest(request: NSMutableURLRequest, completion: ((parsedJSONData: AnyObject?) -> Void)?) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, requestError in
            if let error = requestError {
                println("ERROR: Could not complete the request \(error)")
            } else {
                let parsedData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)

                completion?(parsedJSONData: parsedData)
            }
        }

        task.resume()
    }

    // Add application ID and REST API key to request
    private func addAppIDAndAPIKeyToRequest(request: NSMutableURLRequest) {
        request.addValue(Defaults.ParseApplicationID, forHTTPHeaderField: HeaderFields.ParseApplicationID)
        request.addValue(Defaults.RESTAPIKey, forHTTPHeaderField: HeaderFields.RESTAPIKey)
    }

    // Construct JSON object for HTTP body given parameters
    private func constructJSONObjectFromParameters(parameters: [String:AnyObject]) -> AnyObject {
        return parameters as AnyObject
    }

    // MARK: - From JSON to Structured PropertyList

    private func studentLocationsFromJSONResponse(jsonResponse: AnyObject?) -> [StudentLocation] {
        var result = [StudentLocation]()

        if let jsonObject = jsonResponse as? [String:AnyObject],
            results = jsonObject[JSONKeys.MainKey] as? [[String:AnyObject]] {
            for jsonDictionary in results {
                var studentLocation = StudentLocation(jsonDictionary: jsonDictionary)
                result.append(studentLocation)
            }
        }

        return result
    }
}

extension ParseAPI {
    // General magic values
    private struct Defaults {

        static let SecureBaseURL = "https://api.parse.com/1/classes/"

        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

        static let MaximumStudentsNumberToFetch = 200
    }

    // API methods
    private struct Methods {
        static let StudentLocation = "StudentLocation"
    }

    // HTTP parameters
    private struct Parameters {
        static let Limit = "limit"
    }

    // HTTP header fields
    private struct HeaderFields {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
    }

    // JSON keys
    struct JSONKeys {
        static let MainKey = "results"

        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}