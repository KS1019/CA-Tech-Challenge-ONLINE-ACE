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

}
