//
//  ReservedViewModelTest.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/30.
//

import XCTest

class ReservedViewModelTest: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    var vm: ReservedViewModel!
    var repository: MockTimeTableRepository!

    override func setUp() {
        super.setUp()
        repository = MockTimeTableRepository()
        vm = ReservedViewModel(repository: repository)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_onAppear時timetableに依存する値が更新されているか() {
        vm.onAppear()
        XCTAssertFalse(vm.timetables.isEmpty)
        XCTAssertFalse(vm.labels.isEmpty)
        XCTAssertFalse(vm.selectedGenreFilters.isEmpty)
    }

    func test_予約を取り消した時にtimetableが更新されているか() {
        vm.onAppear()
        vm.deleteReservation(programId: "mockTimetable")
        XCTAssertEqual(repository.deleteFuncCallCount, 1)
        XCTAssertFalse(vm.isLoading)

    }

    func test_予約取り消し時にisAlertが変更されているか() {
        vm.onAppear()
        // 失敗時
        repository.mode = .failure
        vm.deleteReservation(programId: "mockTimetable")
        XCTAssertTrue(vm.isAlert)

        // 成功時
        repository.mode = .success
        vm.deleteReservation(programId: "mockTimetable")
        XCTAssertFalse(vm.isAlert)

    }
}
