//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 12.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

class StudentLocation: NSObject {

    // MARK: - Fields

    var objectID: String! = nil
    var uniqueKey: String! = nil

    var firstName: String! = nil
    var lastName: String! = nil

    var mapString: String! = nil

    var mediaURL: String! = nil

    var latitude: Double! = nil
    var longitude: Double! = nil

    var createdAt: String! = nil
    var updatedAt: String! = nil

    var ACL: String? = nil
}

extension StudentLocation {

    convenience init(jsonDictionary: [String:AnyObject]) {
        self.init()

        if let objectID = jsonDictionary[ParseAPI.JSONKeys.ObjectID] as? String { self.objectID = objectID }
        if let uniqueKey = jsonDictionary[ParseAPI.JSONKeys.UniqueKey] as? String { self.uniqueKey = uniqueKey }

        if let firstName = jsonDictionary[ParseAPI.JSONKeys.FirstName] as? String { self.firstName = firstName }
        if let lastName = jsonDictionary[ParseAPI.JSONKeys.LastName] as? String { self.lastName = lastName }

        if let mapString = jsonDictionary[ParseAPI.JSONKeys.MapString] as? String { self.mapString = mapString }

        if let mediaURL = jsonDictionary[ParseAPI.JSONKeys.MediaURL] as? String { self.mediaURL = mediaURL }

        if let latitude = jsonDictionary[ParseAPI.JSONKeys.Latitude] as? Double { self.latitude = latitude }
        if let longitude = jsonDictionary[ParseAPI.JSONKeys.Longitude] as? Double { self.longitude = longitude }

        if let createdAt = jsonDictionary[ParseAPI.JSONKeys.CreatedAt] as? String { self.createdAt = createdAt }
        if let updatedAt = jsonDictionary[ParseAPI.JSONKeys.UpdatedAt] as? String { self.updatedAt = updatedAt }
    }

    func toJSONDictionary() -> [String:AnyObject] {
        let result = [
            ParseAPI.JSONKeys.ObjectID : objectID,
            ParseAPI.JSONKeys.UniqueKey : uniqueKey,
            ParseAPI.JSONKeys.FirstName : firstName,
            ParseAPI.JSONKeys.LastName : lastName,
            ParseAPI.JSONKeys.MapString : mapString,
            ParseAPI.JSONKeys.MediaURL : mediaURL,
            ParseAPI.JSONKeys.Latitude : latitude,
            ParseAPI.JSONKeys.Longitude : longitude,
            ParseAPI.JSONKeys.CreatedAt : createdAt,
            ParseAPI.JSONKeys.UpdatedAt : updatedAt
        ]

        return result as! [String : AnyObject]
    }
}