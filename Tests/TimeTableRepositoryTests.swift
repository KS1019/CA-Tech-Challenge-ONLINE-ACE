//
//  TimeTableRepositoryTests.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
@testable import App
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

class TimeTableRepositoryTests: XCTestCase {
    let userId = UUID().uuidString.lowercased()

    // 関数の中にrepositoryやsubscriberインスタンスを宣言
    func test_Channelデータ取得成功時にrecieveValueが呼ばれているか() {

        var repository = TimeTableRepository()
        var subscriptions = Set<AnyCancellable>()

        let exp = expectation(description: #function)
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                }
            } receiveValue: { channelList in

                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 10.0)

    }
    // 関数の中にrepositoryやsubscriberインスタンスを宣言
    func test_データ取得成功時にrecieveValueが呼ばれているか() {
        let repository = TimeTableRepository()
        var subscriptions = Set<AnyCancellable>()
        var response: [TimeTable] = []
        let exp = expectation(description: #function)
        repository.fetchTimeTableData(firstAt: Int((Date.aWeek?[0].timeIntervalSince1970)!), lastAt: Int((Date.aWeek?[1].timeIntervalSince1970)!), channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure: break

                }
            } receiveValue: { timetables in
                response += timetables

                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 100.0)

    }
    
    // 関数の中にrepositoryやsubscriberインスタンスを宣言
//    func test_postReservationData() {
//        let repository = TimeTableRepository()
//        var subscriptions = Set<AnyCancellable>()
//        let exp = expectation(description: #function)
//        repository.postReservationData(userId: userId, programId: "Ep6mk79qcVwQCw")
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("終了コード\(#function)")
//                    exp.fulfill()
//
//                case let .failure(error):
//                    print(error)
//                }
//
//            } receiveValue: {
//            }
//            .store(in: &subscriptions)
//
//        wait(for: [exp], timeout: 20.0)
//    }

    //非同期のテストができない問題
    // GithubActionsの確認のためにコメントアウト
    // 関数の中にrepositoryやsubscriberインスタンスを宣言
    //    func test_getReservationData() {
    //        let repository = TimeTableRepository()
    //        var subscriptions = Set<AnyCancellable>()
    //        var response: [TimeTable] = []
    //        let exp = expectation(description: #function)
    //        repository.fetchReservationData(userId: userId)
    //            .sink { completion in
    //                switch completion {
    //                case .finished:
    //                    print("終了コード")
    //
    //                case let .failure(error):
    //                    print(error)
    //
    //                }
    //
    //            } receiveValue: { timetables in
    //                response += timetables
    //                exp.fulfill()
    //            }
    //            .store(in: &subscriptions)
    //        wait(for: [exp], timeout: 20.0)
    //    }
    // GithubActionsの確認のためにコメントアウト
    // 関数の中にrepositoryやsubscriberインスタンスを宣言
    // postが終わった後にこの関数を呼び出したい。
    //    func test_deleteReservationData() {
    //        let repository = TimeTableRepository()
    //        var subscriptions = Set<AnyCancellable>()
    //        let exp = expectation(description: #function)
    //        repository.deleteReservationData(userId: userId, programId: "Ep6mk79qcVwQCw")
    //            .sink { completion in
    //                switch completion {
    //                case .finished:
    //                    print("終了コード\(#function)")
    //                    exp.fulfill()
    //
    //                case let .failure(error):
    //                    print(error)
    //
    //                }
    //
    //            } receiveValue: {
    //
    //            }
    //            .store(in: &subscriptions)
    //        wait(for: [exp], timeout: 20.0)
    //    }

}
