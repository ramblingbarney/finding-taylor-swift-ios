//
//  OAuthList.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct OAuthList {

    let providers: [String]

    init() {
        self.providers = OAuthProviders.providers
    }
}
