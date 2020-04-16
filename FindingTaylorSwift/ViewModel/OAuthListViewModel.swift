//
//  OAuthListViewModel.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

class OAuthListViewModel {

    var providerList: [String]

    init(providers: [String]) {

        self.providerList = providers
    }

    internal func createOAuthUrl(providerName: String) throws -> URL {

        var authorizationURL = URLComponents()

        switch providerName {
        case "Linkedin":

            let redirectURL =  OAuthRedirectURLS.linkedin.rawValue
            let state = "\(OAuthState.linkedin)\(Int(NSDate().timeIntervalSince1970))"
            authorizationURL.scheme = Linkedin.scheme
            authorizationURL.host = Linkedin.host
            authorizationURL.path = OAuthPaths.linkedinAuthorizeUrl
            authorizationURL.queryItems = [
                URLQueryItem(name: "response_type", value: OAuthResponseType.linkedin),
                URLQueryItem(name: "client_id", value: valueForAPIKey(key: "linkedinId")),
                URLQueryItem(name: "redirect_uri", value: redirectURL),
                URLQueryItem(name: "state", value: state),
                URLQueryItem(name: "scope", value: OAuthScope.linkedin)
            ]
        default:
            print("No OAuth Providers Matched")
        }
        guard let url = authorizationURL.url else { throw OAuthError.urlError(provider: "\(providerName) has failed, try another provider")}

        return url
    }
}
