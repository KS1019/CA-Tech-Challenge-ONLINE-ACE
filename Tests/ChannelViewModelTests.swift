//
//  ChannelViewModelTests.swift
//  Tests
//
//  Created by Kotaro Suto on 2021/08/22.
//

@testable import App
import Combine
import XCTest

class ChannelViewModelTests: XCTestCase {
    var vm: ChannelViewModel!
    var repository: MockTimeTableRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockTimeTableRepository()
        vm = ChannelViewModel(repository: repository)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_updateRepositoriesWhenOnAppear() {
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

    func test_postReservedData() {

        vm.postReservedData("test")
        vm.postReservedData("test2")
        XCTAssertEqual(repository.postFuncCallCount, 2)

    }

}
