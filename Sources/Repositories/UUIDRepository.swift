//
//  UUIDRepository.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/17.
//

import Combine
import Foundation
import KeychainAccess

struct UUIDRepository {
    static let keychain = Keychain(service: "C.ACE.iOS")
    func fetchUUID() throws -> String {
        do {
            guard let token = try UUIDRepository.keychain.get("userid") else { throw UUIDRepositoryImplError.neverHappenError }
            return token.lowercased()
        } catch let error {
            throw UUIDRepositoryImplError.fetchFailed(error)
        }
    }

    func register(uuid: UUID) throws {
        let key = uuid.uuidString
        if try UUIDRepository.keychain.get("userid") != nil {
            throw UUIDRepositoryImplError.tokenAlreadySet
        } else {
            do {
                try UUIDRepository.keychain.set(key, key: "userid")
            } catch let error {
                throw UUIDRepositoryImplError.registerFailed(error)
            }
        }
    }

    func update(userID: UUID) throws {
        do {
            try UUIDRepository.keychain.set(userID.uuidString, key: "userid")
        } catch let error {
            throw UUIDRepositoryImplError.updateFailed(error)
        }
    }
}

extension UUIDRepository {
    enum UUIDRepositoryImplError: Error {
        case tokenAlreadySet
        case registerFailed(Error)
        case fetchFailed(Error)
        case updateFailed(Error)
        // This error should never happen
        case neverHappenError
    }
}
