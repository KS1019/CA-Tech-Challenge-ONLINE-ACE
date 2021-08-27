//
//  MockTimeTableRepositoryImpl.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/17.
//

import Combine
import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift

class MockTimeTableRepository: TimeTableRepositoryProtocol {
    func fetchReservationData(userId: String) -> AnyPublisher<[TimeTable], Error> {
        // テスト用に成功するものだけを返す
        let future = Future<[TimeTable], Error> { c in
            c(.success([]))
        }

        return future.eraseToAnyPublisher()

    }

    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {
        // テスト用に成功するものだけを返す
        let future = Future<Void, Error> { completion in
            completion(.success(print("必ず成功します")))
        }
        return future.eraseToAnyPublisher()
    }

    func postReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {
        // テスト用に成功するものだけを返す
        let future = Future<Void, Error> { completion in
            completion(.success(print("必ず成功します")))
        }
        return future.eraseToAnyPublisher()

    }

    init() {
        stub(condition: isHost("C.ACE.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("TimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }

        stub(condition: isHost("C.ACE.ace-c-ios-channel-list")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("ChannelList.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }

    }

    func fetchChannelData() -> AnyPublisher<[Channel], Error> {
        let future = Future<[Channel], Error> { c in
            c(.success([Channel(id: "test-id", title: "test-title")]))
        }

        return future.eraseToAnyPublisher()
    }

    func fetchTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) -> AnyPublisher<[TimeTable], Error> {
        // swiftlint:disable force_unwrapping
        let url = MockTimeTableRepository.baseURL.queryItemAdded(name: "channelId", value: channelId)!
        print(url)
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(TimeTableResult.self, from: $0.data).programs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchFailureTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error> {

        // swiftlint:disable force_unwrapping
        let url = MockTimeTableRepository.failedURL.queryItemAdded(name: "channelId", value: channelId)!
        print(url)
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(TimeTableResult.self, from: $0.data).programs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchReservations(userId: String) -> AnyPublisher<[TimeTable], Error> {
        let url = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record/userId/\(userId)")!
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap {
                try JSONDecoder().decode(TimeTableResult.self, from: $0.data).programs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension MockTimeTableRepository {
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!
    static let failedURL = URL(string: "https://failure.ace-c-ios/projects")!
    static let channelListURL = URL(string: "https://C.ACE.ace-c-ios-channel-list/projects")!
}
