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

class MockTimeTableRepositoryImpl: TimeTableRepository {
    func deleteReservationData(userId: String, programId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "program_id", value: programId)
        ]
        // swiftlint:disable force_unwrapping
        var request = URLRequest(url: TimeTableRepositoryImpl.deleteURL.queryItemsAdded(queryItems)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                return completion(.failure(TimeTableRepositoryImpl.HTTPError.statusCodeError))
            }
            print(response.statusCode)
            completion(.success(()))

        }.resume()
    }

    func postReservationData(userId: String, programId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(fatalError("postReservationData")))
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
        let url = MockTimeTableRepositoryImpl.channelListURL
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
    static let channelListURL = URL(string: "https://C.ACE.ace-c-ios-channel-list/projects")!
}
