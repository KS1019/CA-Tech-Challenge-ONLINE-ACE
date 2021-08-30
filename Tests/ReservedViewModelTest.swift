//
//  ReservedViewModelTest.swift
//  Tests
//
//  Created by TanakaHirokazu on 2021/08/30.
//

import XCTest

class ReservedViewModelTest: XCTestCase {

    func test_updateRepositoriesWhenOnAppear() {
        let vm = ReservedViewModel(repository: MockTimeTableRepository())
        vm.onAppear()
        XCTAssertTrue(!vm.timetables.isEmpty)
    }

    func test_updateRespsitoryesWhenDeleteReservation() {
        let vm = ReservedViewModel(repository: MockTimeTableRepository())

        // vm.onAppear()で空でないことを証明したのでローカルで要素を追加してもOK
        vm.timetables.append(TimeTable(
                                id: "mockTimetable",
                                title: "mockTimetable",
                                highlight: "mockTimetable",
                                detailHighlight: "mockTimetable",
                                startAt: 100,
                                endAt: 200,
                                channelId: "mockTimetable",
                                labels: ["mockTimetable"],
                                content: "mockTimetable"))

        vm.deleteReservation(programId: "mockTimetable")

    }

    func test_failureDeleteReservationWhenAlertIsOn() {
        let failureVm = ReservedViewModel(repository: MockTimeTableRepository(mode: .failure))
        failureVm.deleteReservation(programId: "mockTimetable")
        XCTAssertTrue(failureVm.isAlert)

        let isAlert = failureVm.isAlert

        let successVm = ReservedViewModel(repository: MockTimeTableRepository(mode: .success))
        //失敗時のisAlertを代入して失敗時を再現
        successVm.isAlert = isAlert
        successVm.deleteReservation(programId: "mockTimetable")
        XCTAssertFalse(successVm.isAlert)

    }
}
