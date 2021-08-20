//
//  UUIDRepository.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/17.
//

import Combine
import Foundation
import KeychainAccess

struct UUIDRepositoryImpl {
    static let keychain = Keychain(service: "C.ACE.iOS")
    func fetchUUID() throws -> String {
        do {
            guard let token = try UUIDRepositoryImpl.keychain.get("userid") else { throw UUIDRepositoryImplError.neverHappenError }
            return token
        } catch let error {
            throw UUIDRepositoryImplError.fetchFailed(error)
        }
    }

    func register(uuid: UUID) throws {
        let key = uuid.uuidString
        if try UUIDRepositoryImpl.keychain.get("userid") != nil {
            throw UUIDRepositoryImplError.tokenAlreadySet
        } else {
            do {
                try UUIDRepositoryImpl.keychain.set(key, key: "userid")
            } catch let error {
                throw UUIDRepositoryImplError.registerFailed(error)
            }
        }
    }

    func update(userID: UUID) throws {
        do {
            try UUIDRepositoryImpl.keychain.set(userID.uuidString, key: "userid")
        } catch let error {
            throw UUIDRepositoryImplError.updateFailed(error)
        }
    }
}

extension UUIDRepositoryImpl {
    enum UUIDRepositoryImplError: Error {
        case tokenAlreadySet
        case registerFailed(Error)
        case fetchFailed(Error)
        case updateFailed(Error)
        // This error should never happen
        case neverHappenError
    }
}
