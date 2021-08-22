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
    let channelViewModel = ChannelViewModel(repository: MockTimeTableRepository())
}

extension ChannelViewModelTests {
    func test_onAppear() {
        //TODO: テストの追加
//        channelViewModel.onAppear()
//        XCTAssertEqual(channelViewModel.channels, [Channel(id: "test-id", title: "test-title")])
//        XCTAssertEqual(channelViewModel.timetables, [TimeTable(id: "", title: "", highlight: "", detailHighlight: "", startAt: 0, endAt: 0, channelId: "", labels: [""], content: "")])
//        XCTAssertEqual(channelViewModel.labels, [""])
//        XCTAssertEqual(channelViewModel.selectedGenreFilters, ["": false])
    }

    func test_getTimeTableData() {
    }

    func test_getChannelData() {
        channelViewModel.getChannelData()
        XCTAssertEqual(channelViewModel.channels, [Channel(id: "test-id", title: "test-title")])
    }

    func test_postReservedData() {
    }
}
