//
//  MockTimeTableRepositoryImpl.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/17.
//
#if DEBUG

import Combine
import Foundation

extension MockTimeTableRepository {

    // 初期化時にモードを指定できる。デフォルトはsuccess
    enum Mode {
        case success
        case failure
    }

}

class MockTimeTableRepository: TimeTableRepositoryProtocol {
    var mode: Mode
    var postFuncCallCount = 0
    var deleteFuncCallCount = 0
    var fetchFuncCallCount = 0
    var fetchReservationFuncCallCount = 0

    init(mode: Mode = .success) {
        self.mode = mode
    }
    func postReservationData(reservationData: ReservationData) -> AnyPublisher<ErrorCode?, Error> {
        // postがよばれた回数
        postFuncCallCount += 1
        let future = Future<ErrorCode?, Error> { completion in
            switch self.mode {
            case .success:
                completion(.success(nil))
            case .failure:
                completion(.failure(TimeTableRepository.HTTPError.statusCodeError))
            }
        }
        return future.eraseToAnyPublisher()

    }

    func fetchReservationData(userId: String) -> AnyPublisher<[TimeTable], Error> {
        // テスト用に成功するものだけを返す
        fetchReservationFuncCallCount += 1
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
        // deleteが呼ばれた回数
        deleteFuncCallCount += 1
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

        fetchFuncCallCount += 1

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
#endif
