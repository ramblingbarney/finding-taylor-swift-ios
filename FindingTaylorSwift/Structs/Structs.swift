//
//  Structs.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 05/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import Foundation

struct KeychainConfiguration {
    static let serviceName = "BrickMatcherSerice"

    // static let accessGroup = "[YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared"

    static let accessGroup: String? = nil

   private init(){}
}

struct Instruction: Codable {
    
    let instructionID: String
    let revID: String
    let descriptionText: String
    let headlineText: String
    let productName: String
    let rowOrder: Int64
    
    private enum CodingKeys: String, CodingKey {
        case instructionID = "_id"
        case revID = "_rev"
        case descriptionText = "description"
        case headlineText = "headline"
        case productName = "productName"
        case rowOrder = "rowOrder"
    }
}
