//
//  JSONConvertTest.swift
//  ace-c-iosTests
//
//  Created by Kotaro Suto on 2021/08/14.
//

import Foundation
import XCTest

class JSONConvertTest: XCTestCase {
    func test_JSONの変換() throws {
        let valueFromJSON = try XCTUnwrap(JSONDecoder().decode(TimeTable.self, from: JSONConvertTest.json))

        let expectedValue = TimeTable(id: "EQYyywjosSkxUX", title: "ENLIGHT #1", highlight: "t", detailHighlight: "",
                                      startAt: 1_627_232_880, endAt: 1_627_237_860, channelId: "fishing",
                                      labels: ["live": false, "first": false, "last": false, "bundle": false, "new": false, "pickup": false], content: "",
                                      displayProgram: DisplayProgram(credit:
                                                                        DisplayProgram.Credit(casts: ["川村光太郎"],
                                                                                              crews: ["プロデューサー:松尾健司"],
                                                                                              copyrights: ["(C)テレビ朝日"]),
                                                                     // swiftlint:disable line_length
                                                                     content: "「いつも通り、目一杯釣るだけ! 簡単にはいかないと思いますが、苦しむ僕を見てください!」と話す 日本最高レベルの岸釣りアングラー川村光大郎の新番組『ENLIGHT』初回は霞ケ浦の流入河川で40UPを狙う!"))

        XCTAssertEqual(valueFromJSON, expectedValue)
    }
}

extension JSONConvertTest {
    // swiftlint:disable force_unwrapping
    static let json = """
        {"id": "EQYyywjosSkxUX",
            "title": "ENLIGHT #1",
            "startAt": 1627232880,
            "endAt": 1627237860,
            "channelId": "fishing",
            "groupId": "",
            "highlight": "t",
            "detailHighlight": "",
            "content": "",
            "labels": {
                "live": false,
                "first": false,
                "last": false,
                "bundle": false,
                "new": false,
                "pickup": false
            },
            "displayProgram": {
                "id": "151-95_s0_p1",
                "series": {
                    "id": "151-95"
                },
                "credit": {
                    "casts": [
                        "川村光太郎"
                    ],
                    "crews": [
                        "プロデューサー:松尾健司"
                    ],
                    "copyrights": [
                        "(C)テレビ朝日"
                    ]
                },
                "content": "「いつも通り、目一杯釣るだけ! 簡単にはいかないと思いますが、苦しむ僕を見てください!」と話す 日本最高レベルの岸釣りアングラー川村光大郎の新番組『ENLIGHT』初回は霞ケ浦の流入河川で40UPを狙う!"
            }
        }
        """.data(using: .utf8)!
}
