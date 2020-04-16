//
//  ApiKeys.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct SecretKeys: Codable {
    var accessKey: String
    var secretKey: String
    var linkedinId: String
    var linkedinSecret: String

    enum CodingKeys: String, CodingKey {
        case accessKey = "ACCESS_KEY"
        case secretKey = "SECRET_KEY"
        case linkedinId = "LINKEDIN_ID"
        case linkedinSecret = "LINKEDIN_SECRET"
    }
}

internal func valueForAPIKey(key: String) -> String {

    var returnValue = ""

    if  let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let preferences = try? PropertyListDecoder().decode(SecretKeys.self, from: xml) {

        switch key {
        case "accessKey":
            returnValue = preferences.accessKey
        case "secretKey":
            returnValue = preferences.secretKey
        case "linkedinId":
            returnValue = preferences.linkedinId
        case "linkedinSecret":
            returnValue = preferences.linkedinSecret
        default:
            print("no api keys or secrets matched")
        }
    }
    return returnValue
}
