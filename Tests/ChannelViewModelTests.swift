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
    let channelViewModel = ChannelViewModel(repository: MockTimeTableRepositoryImpl())
}

extension ChannelViewModelTests {
    func test_onAppear() {
        channelViewModel.onAppear()
        XCTAssertEqual(channelViewModel.channels, [Channel(id: "", title: "")])
        XCTAssertEqual(channelViewModel.timetables, [MockTimeTable()])
        XCTAssertEqual(channelViewModel.labels, [""])
        XCTAssertEqual(channelViewModel.selectedGenreFilters, ["": false])
    }

}
