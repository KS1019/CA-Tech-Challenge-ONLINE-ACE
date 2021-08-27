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
    
        let vm = CalendarViewModel(repository: MockTimeTableRepository())
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

            } receiveValue: { data in
                XCTAssertNotNil(data)

            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 10)

    }
    

}
