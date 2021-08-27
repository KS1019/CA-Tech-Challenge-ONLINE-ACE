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

    func test_changeDataWhenChangeDate() {
        let vm = CalendarViewModel(repository: MockTimeTableRepository())

        vm.selectedIndex = 3
        let tmpTimetable = vm.timetables
        vm.onChangeDate()
        let changeTimetable = vm.timetables

        XCTAssertNotEqual(tmpTimetable, changeTimetable)
    }

}
