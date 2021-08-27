//
//  CaneldarViewModelTests.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/27.
//
import Combine
import XCTest

class CaneldarViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    func test_updateRepositoriesWhenOnAppear() {
        //        let vm = CalendarViewModel(repository: MockTimeTableRepository())
        //        vm.onAppear()
        //        XCTAssertTrue(!vm.timetables.isEmpty)  onAppearが非同期のためテストできない。
        //        以下はvm.onAppear()の処理
        let repository = MockTimeTableRepository()
        var subscriptions = Set<AnyCancellable>()

        let exp = expectation(description: #function)
        repository.fetchTimeTableData(firstAt: 1, lastAt: 2, channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished:
                    print("CalendarViewModelのデータ取得成功\(#function)")
                    exp.fulfill()
                case let .failure(error):
                    XCTAssertNil(error)
                }

            } receiveValue: { data in
                XCTAssertNotNil(data)

            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 10)

    }
    
    
    
    
}
