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
    var userPasswordUpdateStatus: UserPasswordUpdateStatus?
    var userAuthenticationError: Observable<Error>?
    var userAuthenticationResult: Observable<SignInResult>?
    var userSignUpError: Observable<Error>?
    var userConfirmSignUpError: Observable<Error>?
    var userConfirmSignUpResult: Observable<SignUpResult>?
    var updatePasswordWithConfirmationCodeError: Observable<Error>?
    var updatePasswordWithConfirmationCodeResult: Observable<ForgotPasswordResult>?
    var awsUserNameEmail: String?
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

    internal func createUser(userName: String, password: String) {

        let result = AWSMobileClient.default().rx.signUp(username: userName, password: password)
            .materialize()

        result
            .compactMap { $0.element }
            .subscribe(onNext: { signUpResult in
                switch signUpResult.signUpConfirmationState {
                case .confirmed:
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    //                case .unknown:
                //                    print("Unexpected case")
                default:
                    print("Unexpected case")
                }
            })
            .disposed(by: disposeBag)
        userSignUpError = result.compactMap { $0.error }
    }

    internal func resendCode(username: String) {
        AWSMobileClient.default().resendSignUpCode(username: username, completionHandler: { (result, error) in
            if let signUpResult = result {
                print("A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        })
    }

    internal func confirmSignUp(username: String, confirmationCode: String) {

        let result = AWSMobileClient.default().rx.confirmSignUp(username: username, confirmationCode: confirmationCode)
            .materialize()

        result
            .compactMap { $0.element }
            .subscribe(onNext: { signUpResult in
                switch signUpResult.signUpConfirmationState {
                case .confirmed:
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    print("Unexpected case")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            })
            .disposed(by: disposeBag)
        userConfirmSignUpError = result.compactMap { $0.error }
        userConfirmSignUpResult = result.compactMap { $0.element }

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
        userAuthenticationResult = result.compactMap { $0.element }
    }

    internal func userLogout() {
        AWSMobileClient.default().signOut()
    }

    internal func forgotPasswordGetConfirmationCode(username: String) {

        self.awsUserNameEmail = username

        AWSMobileClient.default().forgotPassword(username: username) { (forgotPasswordResult, error) in
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

    internal func updatePasswordWithConfirmationCode(newPassword: String, confirmationCode: String) {

        guard let username = self.awsUserNameEmail else { return }

        let result = AWSMobileClient.default().rx.confirmForgotPassword(username: username, newPassword: newPassword, confirmationCode: confirmationCode)
            .materialize()

        result
            .compactMap { $0.element }
            .subscribe(onNext: { forgotPasswordResult in
                switch forgotPasswordResult.forgotPasswordState {
                case .done:
                    print("Password changed successfully")
                    self.userPasswordUpdateStatus = .passwordUpdateSuccessful
                default:
                    print("Error: Could not change password.")
                }
            })
            .disposed(by: disposeBag)
        updatePasswordWithConfirmationCodeError = result.compactMap { $0.error }
        updatePasswordWithConfirmationCodeResult = result.compactMap { $0.element }
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

    func signUp(username: String, password: String) -> Observable<SignUpResult> {
        return Observable.create { observer in
            self.base.signUp(username: username, password: password) { (signUpResult, error) in
                if let signUpResult = signUpResult {
                    observer.onNext(signUpResult)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }

    func confirmSignUp(username: String, confirmationCode: String) -> Observable<SignUpResult> {
        return Observable.create { observer in
            self.base.confirmSignUp(username: username, confirmationCode: confirmationCode) { (signUpResult, error) in
                if let signUpResult = signUpResult {
                    observer.onNext(signUpResult)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }

    func confirmForgotPassword(username: String, newPassword: String, confirmationCode: String) -> Observable<ForgotPasswordResult> {
        return Observable.create { observer in
            self.base.confirmForgotPassword(username: username, newPassword: newPassword, confirmationCode: confirmationCode) { (confirmForgotPasswordResult, error) in
                if let confirmForgotPasswordResult = confirmForgotPasswordResult {
                    observer.onNext(confirmForgotPasswordResult)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }
}
