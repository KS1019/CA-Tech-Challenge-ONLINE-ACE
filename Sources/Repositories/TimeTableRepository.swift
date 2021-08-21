//
//  TimeTableRepository.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Combine
import Foundation

protocol TimeTableRepository {
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error>
    func fetchChannelData() -> AnyPublisher<[Channel], Error>
    func postReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error>
    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error>
}

class TimeTableRepositoryImpl: TimeTableRepository {
    func postReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {
        let future = Future<Void, Error> { completion in
            let params: [String: Any] = ["user_id": userId, "program_id": programId]
            var request = URLRequest(url: TimeTableRepositoryImpl.postURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // httpBodyを作る際に、ここのtry catchが必須なためAnyPublisher<Void, Error>を返すことができない。
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                return completion(.failure(TimeTableRepositoryImpl.HTTPError.httpBodyError))
            }

            request.httpBody = httpBody
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
        return future.eraseToAnyPublisher()

    }

    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {

        let queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "program_id", value: programId)
        ]
        var request = URLRequest(url: TimeTableRepositoryImpl.deleteURL.queryItemsAdded(queryItems)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    throw TimeTableRepositoryImpl.HTTPError.statusCodeError
                }
                return
            }
            .mapError { error in error }
            .eraseToAnyPublisher()
    }
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error> {

        // swiftlint:disable force_unwrapping
        let url = TimeTableRepositoryImpl.baseURL.queryItemAdded(name: "channelId", value: channelId)!
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

        var queryItems = [
            URLQueryItem(name: "first_at", value: String(firstAt)),
            URLQueryItem(name: "last_at", value: String(lastAt))
        ]

        if let channelId = channelId {
            queryItems.append(URLQueryItem(name: "channel_id", value: channelId))
        }
        if let labels = labels {
            queryItems.append(URLQueryItem(name: "labels", value: labels))
        }
        // swiftlint:disable force_unwrapping
        let url = TimeTableRepositoryImpl.getTimetableURL.queryItemsAdded(queryItems)!
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(TimeTableResult.self, from: $0.data).programs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchChannelData() -> AnyPublisher<[Channel], Error> {

        // swiftlint:disable force_unwrapping
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

}

extension TimeTableRepositoryImpl {
    /// TODO: 本番環境のURLに修正
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!
    static let getTimetableURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/list")!
    static let getChannelURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/")!
    static let deleteURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record")!
    static let postURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record")!

    enum HTTPError: Error {
        case httpBodyError
        case statusCodeError
    }

}
