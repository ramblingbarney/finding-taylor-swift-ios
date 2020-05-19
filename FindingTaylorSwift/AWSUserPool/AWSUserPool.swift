//
//  AWSUserPool.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import UIKit
import RxSwift

class AWSUserPool {

    var userAuthenticationStatus: UserAuthenticationState?
    var userAuthenticationError: Observable<Error>?
    private let disposeBag = DisposeBag()

    internal init() {
        initalizeAWSMobileClient()
    }

    static let shared = AWSUserPool()

    private func initalizeAWSMobileClient() {

        AWSMobileClient.default().initialize { (userState, error ) in

            if let userState = userState {
                switch userState {
                case .signedIn:
                    print("Logged In")
                    print("Cognito Identity Id (authenticated): \(String(describing: AWSMobileClient.default().identityId))")
                    self.userAuthenticationStatus = .signedIn
                case .signedOut:
                    print("Logged Out")
                    self.userAuthenticationStatus = .signedOut
                case .signedOutUserPoolsTokenInvalid:
                    print("User Pools refresh token is invalid or expired.")
                    self.userAuthenticationStatus = .signedOutUserPoolsTokenInvalid
                case .signedOutFederatedTokensInvalid:
                    print("Federated refresh token is invalid or expired.")
                    self.userAuthenticationStatus = .signedOutFederatedTokensInvalid
                default:
                    self.userAuthenticationStatus = .signedOut
                    AWSMobileClient.default().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    internal func userLogin(userName: String, password: String) {

        let result = AWSMobileClient.default().rx.signIn(username: userName, password: password)
            .materialize()

        result
            .compactMap { $0.element }
            .subscribe(onNext: { signinResult in
                switch signinResult.signInState {
                case .signedIn:
                    print("User is signed in.")
                    self.userAuthenticationStatus = .signedIn
                case .smsMFA:
                    print("SMS message sent to \(signinResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            })
            .disposed(by: disposeBag)
        userAuthenticationError = result.compactMap { $0.error }
    }

    internal func userLogout() {
        AWSMobileClient.default().signOut()
    }

    internal func forgotPasswordGetConfirmationCode(username: String) {

        AWSMobileClient.default().forgotPassword(username: "my_username") { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch forgotPasswordResult.forgotPasswordState {
                case .confirmationCodeSent:
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                default:
                    print("Error: Invalid case.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }

    internal func updatePasswordWithConfirmationCode(username: String, newPassword: String, confirmationCode: Int) {

        AWSMobileClient.default().confirmForgotPassword(username: "my_username", newPassword: "MyNewPassword123!!", confirmationCode: "ConfirmationCode") { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch forgotPasswordResult.forgotPasswordState {
                case .done:
                    print("Password changed successfully")
                default:
                    print("Error: Could not change password.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
}

extension Reactive where Base: AWSMobileClient {
    func signIn(username: String, password: String) -> Observable<SignInResult> {
        return Observable.create { observer in
            self.base.signIn(username: username, password: password) { (signinResult, error) in
                if let signinResult = signinResult {
                    observer.onNext(signinResult)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }
}
