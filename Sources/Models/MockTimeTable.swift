//
//  MockTimeTable.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/13.
//

import Foundation

struct MockTimeTable: TimeTableProtocol {
    var id: String

    var title: String

    var highlight: String

    var detailHighlight: String

    var startAt: Int

    var endAt: Int

    var channelId: String

    var labels: [String: Bool]

    init() {
        self.id = "EQYyywjosSkxUX"
        self.title = "ENLIGHT #1"
        self.highlight = "Test Highlight"
        self.detailHighlight = "Test detailHighlight"
        self.startAt = 1_627_232_880
        self.endAt = 1_627_237_860
        self.channelId = "fishing"
        self.labels = [
            "live": false,
            "first": false,
            "last": false,
            "bundle": false,
            "new": false,
            "pickup": false
        ]
    }

}
