//
//  TimeTableRepositoryTests.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
@testable import ace_c_ios
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

class TimeTableRepositoryTests: XCTestCase {
    var repository = TimeTableRepositoryImpl()
    var isError = false
    private var subscriptions = Set<AnyCancellable>()
    var response: [TimeTable] = []

    override func setUp() {
        super.setUp()
        // 成功用のスタブ
        stub(condition: isHost("C.ACE.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("TimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }
        // 失敗用のスタブ
        stub(condition: isHost("failure.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("FailureTimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }
    }

    func test_データ取得成功時にrecieveValueが呼ばれているか() {

        let exp = expectation(description: #function)
        repository.fetchTimeTableData(channelId: "fishing")
            .sink { completion in
                switch completion {
                case .finished: break

                case let .failure(error):
                    XCTAssertNotNil(error)

                }
            } receiveValue: { timetables in
                self.response += timetables
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 3.0)

    }

    func test_データ取得失敗時にfailureが呼ばれているか() {
        let exp = expectation(description: #function)
        repository.fetchFailureTimeTableData(channelId: "fishing")
            .sink { completion in
                switch completion {
                case .finished: break

                case let .failure(error):
                    XCTAssertNotNil(error)
                    exp.fulfill()
                    self.isError = true
                    XCTAssertEqual(self.isError, true)

                }
            } receiveValue: { timetables in
                self.response += timetables

            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 3.0)
    }
}