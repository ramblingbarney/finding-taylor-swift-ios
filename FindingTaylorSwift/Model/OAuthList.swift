//
//  OAuthList.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 12/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct OAuthList {

    let providers: [String]

    init() {
        self.providers = OAuthProviders.providers
    }
}
