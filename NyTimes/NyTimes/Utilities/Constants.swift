//
//  Constants.swift
//  NyTimes
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import Foundation

// MARK: - Server related constants
struct Server {

    /// Api key for server communication
    static let apiKey: String = {
        return "api-key=GLdHw57A1S543pjSPVbQsAYe1OMO9GlA"
    }()

    /// Server url
    static let url: String  = {
        return "https://api.nytimes.com/svc/mostpopular/v2/"
    }()

    /// Response format to be received
    static let typeExtension: String  = {
        return ".json?"
    }()
}

// MARK: - API EndPoints
struct EndPoints {
    static let mostViewed = "viewed/"
}

// MARK: - Period
/// Number of days
enum ArticlePeriod: String {
    case day = "1"
    case week = "7"
    case month = "30"
}

// MARK: - Global constants
enum Constants {
    static let period = "PERIOD_LENGTH"
}
