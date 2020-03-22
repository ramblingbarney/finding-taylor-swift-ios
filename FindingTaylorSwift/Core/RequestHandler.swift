//
//  RequestHandler.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import Foundation

enum Outcome<T> {
    case success(T)
    case failure(String)
}

protocol Parser {
    func parse<T>(_ data: Data, into: T.Type, completion: (Outcome<T>) -> Void) where T: Codable
}

struct JSONParser: Parser {

    func parse<T>(_ data: Data, into: T.Type, completion: (Outcome<T>) -> Void) where T: Decodable, T: Encodable {

        do {
            let result = try JSONDecoder().decode(into, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error.localizedDescription))
        }

    }
}
