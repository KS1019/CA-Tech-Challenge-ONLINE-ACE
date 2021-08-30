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

extension MockTimeTableRepository {

    // 初期化時にモードを指定できる。デフォルトはsuccess
    enum Mode {
        case success
        case failure
    }

}

class MockTimeTableRepository: TimeTableRepositoryProtocol {
    let mode: Mode

    init(mode: Mode = .success) {
        self.mode = mode

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
    func fetchReservationData(userId: String) -> AnyPublisher<[TimeTable], Error> {
        // テスト用に成功するものだけを返す
        let future = Future<[TimeTable], Error> { completion in
            switch self.mode {
            case .success:
                completion(.success([
                    TimeTable(
                        id: "mockTimetable",
                        title: "mockTimetable",
                        highlight: "mockTimetable",
                        detailHighlight: "mockTimetable",
                        startAt: 100,
                        endAt: 200,
                        channelId: "mockTimetable",
                        labels: ["mockTimetable"],
                        content: "mockTimetable")
                ]))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.httpBodyError))
            }

        }

        return future.eraseToAnyPublisher()

    }

    func deleteReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {
        // テスト用に成功するものだけを返す
        let future = Future<Void, Error> { completion in
            switch self.mode {
            case .success:
                completion(.success(print("必ず成功します")))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
            }
        }
        return future.eraseToAnyPublisher()
    }

    func postReservationData(userId: String, programId: String) -> AnyPublisher<Void, Error> {
        // テスト用に成功するものだけを返す
        let future = Future<Void, Error> { completion in
            switch self.mode {
            case .success:
                completion(.success(print("必ず成功します")))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
            }
        }
        return future.eraseToAnyPublisher()

    }

    func fetchChannelData() -> AnyPublisher<[Channel], Error> {
        let future = Future<[Channel], Error> { completion in
            switch self.mode {
            case .success:
                completion(.success([Channel(id: "test-id", title: "test-title")]))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
            }
        }

        return future.eraseToAnyPublisher()
    }

    func fetchTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) -> AnyPublisher<[TimeTable], Error> {

        let future = Future<[TimeTable], Error> { completion in
            switch self.mode {
            case .success:
                completion(.success([
                    TimeTable(
                        id: "mockTimetable",
                        title: "mockTimetable",
                        highlight: "mockTimetable",
                        detailHighlight: "mockTimetable",
                        startAt: 100,
                        endAt: 200,
                        channelId: "mockTimetable",
                        labels: ["mockTimetable"],
                        content: "mockTimetable")
                ]))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
            }
        }

        return future.eraseToAnyPublisher()

    }

}

extension MockTimeTableRepository {
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!
    static let failedURL = URL(string: "https://failure.ace-c-ios/projects")!
    static let channelListURL = URL(string: "https://C.ACE.ace-c-ios-channel-list/projects")!
}
