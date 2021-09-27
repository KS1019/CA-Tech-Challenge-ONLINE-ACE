//
//  TimeTableRepository.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Combine
import Foundation

protocol TimeTableRepositoryProtocol {
    func fetchChannelData() -> AnyPublisher<[Channel], Error>
    func postReservationData(reservationData: ReservationData) -> AnyPublisher<ErrorCode?, Error>
    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error>
    func fetchTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) -> AnyPublisher<[TimeTable], Error>
    func fetchReservationData(userId: String) -> AnyPublisher<[TimeTable], Error>
}

struct ErrorCode: Decodable {
    let error: String
    let code: Int
}
class TimeTableRepository: TimeTableRepositoryProtocol {

    let decoder = JSONDecoder()
    let apiProvider: APIProvider
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetchReservationData(userId: String) -> AnyPublisher<[TimeTable], Error> {
        var url = TimeTableRepository.getReservedURL
        url.appendPathComponent(userId)
        let request = URLRequest(url: url)
        return apiProvider
            .apiResponse(for: request)
            .tryMap {
                try self.decoder.decode(ListResult<TimeTable>.self, from: $0.data).items
            }
            .eraseToAnyPublisher()
    }

    func postReservationData(reservationData: ReservationData) -> AnyPublisher<ErrorCode?, Error> {
        //        let future = Future<Void, Error> { completion in
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        var request = URLRequest(url: TimeTableRepository.postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? encoder.encode(reservationData) else {
            return Fail<ErrorCode?, Error>(error: TimeTableRepository.HTTPError.httpBodyError)
                .eraseToAnyPublisher()
            //                別の書き方もできる
            //                return Fail<Void, Error>(error: TimeTableRepository.HTTPError.httpBodyError).eraseToAnyPublisher()
        }

        request.httpBody = httpBody

        return self.apiProvider
            .apiResponse(for: request)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                    return try self.decoder.decode(ErrorCode.self, from: data)
                }
                return nil
            }
            .mapError({ error in
                error
            })
            .eraseToAnyPublisher()

        //            dataTask(with: request) { (data, response, error) in
        //                if let error = error {
        //                    completion(.failure(error))
        //                }
        //
        //
        //
        //                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
        //                    return completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
        //                }
        //                print(response.statusCode)
        //
        //                completion(.success(()))
        //
        //            }.resume()
        //        }

        //        return future.eraseToAnyPublisher()

    }

    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {

        let queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "program_id", value: programId)
        ]
        // swiftlint:disable force_unwrapping
        var request = URLRequest(url: TimeTableRepository.deleteURL.queryItemsAdded(queryItems)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return self.apiProvider.apiResponse(for: request)
            .tryMap { data, response in

                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    throw TimeTableRepository.HTTPError.statusCodeError
                }
                return
            }
            .mapError { error in error }
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
        let url = TimeTableRepository.getTimetableURL.queryItemsAdded(queryItems)!
        let request = URLRequest(url: url)
        return apiProvider.apiResponse(for: request)
            .tryMap { try
                self.decoder.decode(ListResult<TimeTable>.self, from: $0.data).items
            }
            .eraseToAnyPublisher()
    }

    func fetchChannelData() -> AnyPublisher<[Channel], Error> {

        // swiftlint:disable force_unwrapping
        let url = TimeTableRepository.getChannelURL
        let request = URLRequest(url: url)
        return apiProvider.apiResponse(for: request)
            .tryMap { try
                self.decoder.decode(ListResult<Channel>.self, from: $0.data).items
            }
            .eraseToAnyPublisher()
    }
}

extension TimeTableRepository {

    static let getTimetableURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/list")!
    static let getChannelURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/")!
    static let deleteURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record")!
    static let postURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record")!
    static let getReservedURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record/user")!
    enum HTTPError: Error {
        case httpBodyError
        case statusCodeError
    }

}
