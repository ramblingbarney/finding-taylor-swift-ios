//
//  NetworkManager.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import Foundation
import UIKit

// MARK: - Network Manager
class NetworkManager {

    // The session to use to download the data
    private let session: URLSession

    // Create the manager with a given session configuration
    init(_ sessionConfiguration: URLSessionConfiguration = .ephemeral) {
        session = URLSession(configuration: sessionConfiguration)
    }

    static let shared = NetworkManager()

    // A private function to fetch data from a URL
    private func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {

        let request = URLRequest(url: url)

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else if let data = data {
                completion(data)
            }
        }

        dataTask.resume()

    }
}

extension NetworkManager {

    func fetchInstructions(url: URL, completion: @escaping ([Instruction]?) -> Void) {

        // Fetch the data
        fetchData(from: url) { data in

            if let data = data {

                // Parse the response
                do {
                    let value = try JSONDecoder().decode([Instruction].self, from: data)
                    completion(value)
                } catch {
                    print(error)
                    completion(nil)
                }

            } else {
                completion(nil)
            }
        }
    }
}
