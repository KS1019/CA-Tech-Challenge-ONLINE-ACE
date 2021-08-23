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
    func test_Channelデータ取得成功時にrecieveValueが呼ばれているか() {
        var repository = TimeTableRepositoryImpl()
        var subscriptions = Set<AnyCancellable>()

        let exp = expectation(description: #function)
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break
                }
            } receiveValue: { channelList in
                print(channelList)
                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 3.0)

    }

    func test_データ取得成功時にrecieveValueが呼ばれているか() {
        let repository = TimeTableRepositoryImpl()
        var subscriptions = Set<AnyCancellable>()
        var response: [TimeTable] = []
        let exp = expectation(description: #function)
        repository.fetchTimeTableData(firstAt: Int((Date.aWeek?[0].timeIntervalSince1970)!), lastAt: Int((Date.aWeek?[1].timeIntervalSince1970)!), channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished: break

                case let .failure(error):
                    XCTAssertNotNil(error)

                }
            } receiveValue: { timetables in
                response += timetables

                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 10.0)

    }

}
