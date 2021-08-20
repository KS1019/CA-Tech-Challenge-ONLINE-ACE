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
}

class TimeTableRepositoryImpl: TimeTableRepository {
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error> {

        // swiftlint:disable force_unwrapping
        let url = TimeTableRepositoryImpl.baseURL.queryItemAdded(name: "channelId", value: channelId)!
        print(url)
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(TimeTableResult.self, from: $0.data).data
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

    func postReservationData(userId: String, programId: String) throws {
        let params: [String: Any] = ["user_id": userId, "program_id": programId]

        var request = URLRequest(url: TimeTableRepositoryImpl.postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            throw HTTPError.httpBodyError
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
            } else {
                // View側に値を返したい
                print(error?.localizedDescription)
            }
        }.resume()

    }
}

extension TimeTableRepositoryImpl {
    /// TODO: 本番環境のURLに修正
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!
    static let getChannelURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/")!

    static let postURL = URL(string: "https://api.c.ace2108.net/api/v1/channel/program/record")!

    enum HTTPError: Error {
        case httpBodyError
    }

}
