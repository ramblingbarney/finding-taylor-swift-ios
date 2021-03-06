//
//  AWSFileHandler.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore
import KeychainSwift

class AWSFileHandler {

    private let defaults = UserDefaults.standard
    private let keychain = KeychainSwift()
    private var credentials: AWSCredentialsProvider?
    private var configuration: AWSServiceConfiguration?
    weak var delegate: ProgressErrorDelegate?

    init() {
        keychain.set(valueForAPIKey(key: "accessKey"), forKey: "accessKey")
        keychain.set(valueForAPIKey(key: "secretKey"), forKey: "secretKey")
        credentials = AWSStaticCredentialsProvider(accessKey: keychain.get("accessKey")!, secretKey: keychain.get("secretKey")!)
        configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest2, credentialsProvider: credentials)
    }

    func uploadFile(withImage image: UIImage, bucketName: String) {

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let s3BucketName = bucketName
        guard let data: Data = image.pngData() else { return }
        let remoteName = generateRandomStringWithLength(length: 12) + ".png"
        print("REMOTE NAME: ", remoteName)

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async(execute: {
                self.delegate?.startProgressBar()
            })
        }

        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                self.delegate?.completeProgressBar()
            })
        }

        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                                   bucket: s3BucketName,
                                   key: remoteName,
                                   contentType: "image/" + ".png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                // delegate the error
                print("Error : \(error.localizedDescription)")
                self.delegate?.showErrorAlert(errorMessage: error.localizedDescription)
            }

            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(s3BucketName).appendingPathComponent(remoteName)
                if let absoluteString = publicURL?.absoluteString {
                    // Set image with URL
                    print("Image URL : ", absoluteString)
                }
            }
            return nil
        }
    }

    private func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = RandomLetters.letters
        var counter: Int = 0

        while counter < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            counter += 1
        }
        return String(randomString)
    }
}
