//
//  CaneldarViewModelTests.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/27.
//

import XCTest

class CaneldarViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_updateRepositoriesWhenOnAppear() {
        let repository = MockTimeTableRepository()
        let exp = expectation(description: #function)
        repository.fetchTimeTableData(firstAt: 1, lastAt: 1, channelId: nil, labels: nil)
            .sink { completion in
                exp.fulfill()
            } receiveValue: { data in
                XCTAssertNotNil(data)
            }
        wait(for: [exp], timeout: 10)
        //        let vm = CalendarViewModel(repository: repository)
        //        vm.onAppear()
        // onAppearの処理が終わるまで待機したい。

    }
}
