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

// レビューのため,TimeTableRepositoryのプロトコルは外しています。
class MockTimeTableRepositoryImpl: TimeTableRepository {

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
        let url = TimeTableRepositoryImpl.getChannelURL
        print(url)
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(ChannelListResult.self, from: $0.data).channels
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // TODO: 他のViewに依存されているコード　VMに切り出し終えた時に破棄
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error> {

        // swiftlint:disable force_unwrapping
        let url = MockTimeTableRepositoryImpl.baseURL.queryItemAdded(name: "channelId", value: channelId)!
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

    func fetchTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) -> AnyPublisher<[TimeTable], Error> {
        // swiftlint:disable force_unwrapping
        let url = MockTimeTableRepositoryImpl.baseURL.queryItemAdded(name: "channelId", value: channelId)!
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
        let url = MockTimeTableRepositoryImpl.failedURL.queryItemAdded(name: "channelId", value: channelId)!
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

}

extension MockTimeTableRepositoryImpl {
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!
    static let failedURL = URL(string: "https://failure.ace-c-ios/projects")!
    static let channelListURL = URL(string: "https://C.ACE.ace-c-ios-channel-list/projects")
}
