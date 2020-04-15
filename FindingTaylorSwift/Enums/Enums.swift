//
//  Enums.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

enum ProgressNotificationDetails {
    static let kProgressViewTag = 10000
    static let kProgressUpdateNotification = "kProgressUpdateNotification"
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

enum EndPoints {
    static let instructions = "/instructions"
}

enum ProcessingServer {
    static let scheme = "http"
    static let host = "localhost"
    static let port = 8080
}

enum RandomLetters {
    static let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
}

enum SeenHelpInformation {
    static let seenHelp = "seenHelpInformation"
}

enum TextCellIdentifier {
    static let textCellIdentifier = "programmaticSwiftUI"
    static let textCellIdentifierCustomCell = "programmaticSwiftUIOneFourSeven33"
}

enum OAuthProviders {
    static let providers = ["FaceBook", "Google", "Instagram", "Qzone QQ", "Weibo", "Twitter", "Reddit", "Pinterest", "Ask.fm", "Tumblr", "Flickr", "Linkedin", "VK", "Odnoklassniki", "Meetup"]
}

enum OAuthProviderNames: String {
    case linkedin
}

enum OAuthPaths {
    static let linkedinAuthorizeUrl = "/oauth/v2/authorization"
    static let linkedinAccessTokenUrl = "/uas/oauth2/accessToken"
}

enum OAuthUrls {
    static let linkedinAuthorizeUrl = "https://www.linkedin.com/oauth/v2/authorization"
    static let linkedinAccessTokenUrl = "https://www.linkedin.com/oauth/v2/accessToken"
}

enum Linkedin {
    static let scheme = "https"
    static let host = "www.linkedin.com"
}

enum OAuthResponseType {
    static let linkedin = "code"
}

enum OAuthRedirectURLS: String {
    case linkedin = "https://findingtaylorswift.linkedin/oauth"
}

enum OAuthState {
    static let linkedin = "linkedin"
}

enum OAuthScope {
    static let linkedin = "r_liteprofile r_emailaddress"
}

enum OAuthError: Error {
    case urlError(provider: String)
}
