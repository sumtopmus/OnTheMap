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

    func getUsersLocations(completion: ((locations: [OnTheMapLocation]) -> Void)?) {
        println("TODO: Implement GET call for users locations in Parse API")
    }

    func postUserLocation(location: OnTheMapLocation, completion: ((success: Bool) -> Void)?) {
        println("TODO: Implement POST call for user location in Parse API")
    }
}