//
//  ReservedViewModelTest.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/30.
//

import XCTest

class ReservedViewModelTest: XCTestCase {

    func test_onAppear時timetableが更新されているか() {
        let vm = ReservedViewModel(repository: MockTimeTableRepository())
        vm.onAppear()
        XCTAssertFalse(vm.timetables.isEmpty)
        XCTAssertFalse(vm.labels.isEmpty)
        XCTAssertFalse(vm.selectedGenreFilters.isEmpty)
    }

    func test_予約を取り消した時にtimetableが更新されているか() {
        let vm = ReservedViewModel(repository: MockTimeTableRepository())

        vm.onAppear()

        vm.deleteReservation(programId: "mockTimetable")
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.isLoading)

    }

    func test_予約取り消しの失敗時にisAlertが変更されているか() {

        let failureVm = ReservedViewModel(repository: MockTimeTableRepository(mode: .failure))
        failureVm.getReservaions()
        XCTAssertTrue(failureVm.isAlert)
        XCTAssertTrue(failureVm.isLoading)
        failureVm.deleteReservation(programId: "mockTimetable")
        XCTAssertTrue(failureVm.isAlert)
        XCTAssertTrue(failureVm.labels.isEmpty)
        XCTAssertTrue(failureVm.selectedGenreFilters.isEmpty)

        let isAlert = failureVm.isAlert

        let successVm = ReservedViewModel(repository: MockTimeTableRepository(mode: .success))
        // 失敗時のisAlertを代入して失敗時を再現
        successVm.isAlert = isAlert
        successVm.deleteReservation(programId: "mockTimetable")
        XCTAssertFalse(successVm.isAlert)

    }
}
