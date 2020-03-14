//
//  OAuthListViewModel.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 14/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct OAuthListViewModel {

    var providerList: [String]

    init(providers: [String]) {

        self.providerList = providers
    }
}
