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

enum AWSControllers {
    static let signUp = "awsSignUpController"
    static let signIn = "awsSignInController"
    static let forgotPasswordEmail = "awsForgotPasswordEmail"
    static let forgotPasswordUpdate = "awsForgotPasswordUpdate"
    static let awsUpdatedPasswordSuccess = "awsUpdatedPasswordSuccess"
    static let awsConfirmationCode = "awsConfirmationCode"
    static let awsConfirmSignUpUserSuccess = "awsConfirmSignUpUserSuccess"
}

enum UserAuthenticationState {
    case signedIn
    case signedOut
    case signedOutUserPoolsTokenInvalid
    case signedOutFederatedTokensInvalid
    case authenticationError
}

enum LoginError {
    static let userNotFound = "Email does not exist."
    static let incorrectPassword = "Password incorrect."
    static let defaultLoginError = "Incorrect username or password."
}

enum AWSUserAuthenticationNil {
    static let title = "System Error"
    static let message = "User Login Not Available"
}

enum EmailValidationError {
    static let title = "Email"
    static let message = "Email Address Must Be Valid"
}

enum PasswordValidationError {
    static let title = "Password"
    static let message = "Password Does Not Meet The Criteria"
}

enum PasswordValidationErrorMatching {
    static let title = "Both Passwords"
    static let message = "The Passwords Do Not Match"
}

enum ConfirmatiionCodeValidationError {
    static let title = "Confirmation Code"
    static let message = "Failed Validation: Blank or Not A Number"
}

enum ConfirmatiionCodeError {
    static let title = "Account Validation Failed"
    static let message = "Confirmation Code Is Incorrect"
}

enum UpdatePasswordError {
    static let titleDefault = "Password Update Failed"
    static let messageDefault = "Your password has not been updated"
    static let titleCode = "Confirmation Code"
    static let messageCode = "Incorrect Confirmation Code"
    static let titlePassword = "Password"
    static let messagePasswordShort = "New Password Not Accepted: Too Short"
    static let messagePasswordComplexity = "New Password Not Accepted: Too Simple"
}

enum CreateAccountError {
    static let titlePassword = "Password"
    static let titleSignUp = "Create Account Error"
    static let messagePasswordShort = "New Password Not Accepted: Too Short"
    static let messagePasswordComplexity = "New Password Not Accepted: Too Simple"
    static let messageCreateAccountError = "Account Not Created, Please Try Again"
    static let messageCreateAccountEmailReegistered = "This Email Has Already Been Registered"
}

enum UserPasswordUpdateStatus {
    case passwordUpdateSuccessful
}

enum PasswordUpated {
    static let title = "Password Updated"
}
