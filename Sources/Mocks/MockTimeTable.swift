//
//  MockTimeTable.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/13.
//

import Foundation

struct MockTimeTable: TimeTableProtocol {
    var content: String

    var id: String

    var title: String

    var highlight: String

    var detailHighlight: String

    var startAt: Int

    var endAt: Int

    var channelId: String

    var labels: [String: Bool]
    var displayProgram: DisplayProgram
    init() {
        self.id = UUID().uuidString
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
        self.displayProgram = DisplayProgram(credit: DisplayProgram.Credit(casts: [], crews: [], copyrights: []), content: "「いつも通り、目一杯釣るだけ! 簡単にはいかないと思いますが、苦しむ僕を見てください!」と話す 日本最高レベルの岸釣りアングラー川村光大郎の新番組『ENLIGHT』初回は霞ケ浦の流入河川で40UPを狙う!")
        self.content = ""

    }

}
