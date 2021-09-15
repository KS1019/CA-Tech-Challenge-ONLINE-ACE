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
    // swiftlint:disable implicitly_unwrapped_optional
    var vm: ChannelViewModel<ImmediateScheduler>!
    var repository: MockTimeTableRepository!
    var uuidRepository: MockUUIDRepository!
    // repository
    override func setUp() {
        super.setUp()
        repository = MockTimeTableRepository()
        uuidRepository = MockUUIDRepository()
        vm = ChannelViewModel(repository: repository, UUIDRepo: uuidRepository, scheduler: ImmediateScheduler.shared)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_OnAppear時timetableが更新されているか() {
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

    func test_postReservedData時repositoryの関数が正しくよばれているか() {

        vm.postReservedData("test")
        vm.postReservedData("test2")
        XCTAssertEqual(repository.postFuncCallCount, 2)

    }

    func test_PostReservedData時reservedFlagが更新されているか() {
        repository.mode = .success
        vm.postReservedData("test")
        XCTAssertTrue(vm.reservedFlag)
        repository.mode = .failure
        vm.postReservedData("failedtest")
        XCTAssertFalse(vm.reservedFlag)

    }

}
