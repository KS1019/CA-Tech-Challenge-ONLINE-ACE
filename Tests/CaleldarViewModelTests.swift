//
//  CaneldarViewModelTests.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/27.
//
@testable import App
import Combine
import XCTest

class CalendarViewModelTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    var repository: MockTimeTableRepository!
    var UUIDRepo: MockUUIDRepository!
    var vm: CalendarViewModel<ImmediateScheduler>!

    override func setUp() {
        super.setUp()
        repository = MockTimeTableRepository()
        UUIDRepo = MockUUIDRepository()
        vm = CalendarViewModel(repository: repository, UUIDRepo: UUIDRepo, scheduler: ImmediateScheduler.shared)
    }
    override func tearDown() {
        super.tearDown()
    }

    func test_updateRepositoriesWhenOnAppear() {
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

    func test_changeDataWhenChangeDate() {

        vm.selectedIndex = 3
        let tmpTimetable = vm.timetables
        vm.onChangeDate()
        let changeTimetable = vm.timetables
        XCTAssertNotEqual(tmpTimetable, changeTimetable)
    }

    func test_postReservedData() {
        vm.postReservedData("test")
        XCTAssertEqual(repository.postFuncCallCount, 1)
    }
}
