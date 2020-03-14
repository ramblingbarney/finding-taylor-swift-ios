//
//  Enums.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 05/02/2020.
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
}

enum OAuthProviders {
    static let providers = ["FaceBook", "Google", "Instagram", "Qzone QQ", "Weibo", "Twitter", "Reddit", "Pinterest", "Ask.fm", "Tumblr", "Flickr", "Linkedin", "VK", "Odnoklassniki", "Meetup"]
}
