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

    override func setUp() {
        super.setUp()
        vm = ChannelViewModel(repository: MockTimeTableRepository())
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_updateRepositoriesWhenOnAppear() {
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

}
