//
//  CaneldarViewModelTests.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/27.
//
import Combine
import XCTest

class CalendarViewModelTests: XCTestCase {
    var repository: MockTimeTableRepository!
    var UUIDRepo: MockUUIDRepository!
    var vm: CalendarViewModel!

    override func setUp() {
        super.setUp()
        repository = MockTimeTableRepository()
        UUIDRepo = MockUUIDRepository()
        vm = CalendarViewModel(repository: repository, UUIDRepo: UUIDRepo)
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

    func test_fetchUUID時にvmに正しくuserIdが代入されているか() {
        XCTAssertEqual(vm.userId, try UUIDRepo.fetchUUID())
    }

}
