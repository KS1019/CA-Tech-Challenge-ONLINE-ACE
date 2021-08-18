//
//  UUIDRepository.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/17.
//

import Combine
import Foundation
import KeychainAccess

protocol UUIDRepository {
    func fetchUUID() -> AnyPublisher<UUID, Error>
    func register(uuid: UUID)
}

struct UUIDRepositoryImpl {
    static let keychain = Keychain(service: "C.ACE.iOS")
    func fetchUUID() throws -> String {
        do {
            guard let token = try UUIDRepositoryImpl.keychain.get("userid") else { throw UUIDRepositoryImplError.fetchFailed }
            return token
        } catch let error {
            print(error)
            throw UUIDRepositoryImplError.fetchFailed
        }
    }

    func register(uuid: UUID) throws {
        let key = uuid.uuidString
        if try UUIDRepositoryImpl.keychain.get("userid") != nil {
            print("Token is already set")
            throw UUIDRepositoryImplError.tokenAlreadySet
        } else {
            do {
                try UUIDRepositoryImpl.keychain.set(key, key: "userid")
                print("\(key) saved")
            } catch let error {
                print(error)
                throw UUIDRepositoryImplError.registerFailed
            }
        }
    }
}

extension UUIDRepositoryImpl {
    enum UUIDRepositoryImplError: Error {
        case tokenAlreadySet
        case registerFailed
        case fetchFailed
    }
}
