//
//  JSONConvertTest.swift
//  ace-c-iosTests
//
//  Created by Kotaro Suto on 2021/08/14.
//

import Foundation
import XCTest

class JSONConvertTest: XCTestCase {
    func test_JSONが正しくTimetableに変換されているか() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let valueFromJSON = try XCTUnwrap(decoder.decode(TimeTable.self, from: JSONConvertTest.json))

        let expectedValue = TimeTable(
            id: "EQYyywjosSkxUX",
            title: "黒子のバスケ 第1期 全話一挙",
            highlight: "黒子のバスケ 第1期 全話一挙",
            detailHighlight: "",
            startAt: 1_626_238_800,
            endAt: 1_626_278_400,
            channelId: "abema-anime-2",
            labels: ["bundle"], content: ""
        )

        XCTAssertEqual(valueFromJSON, expectedValue)
    }
}

extension JSONConvertTest {
    // swiftlint:disable force_unwrapping
    static let json = """
        {"id":"EQYyywjosSkxUX",
        "title":"黒子のバスケ 第1期 全話一挙",
        "channel_id":"abema-anime-2",
        "labels":["bundle"],
        "highlight":"黒子のバスケ 第1期 全話一挙",
        "detail_highlight":"",
        "content":"",
        "start_at":1626238800,
        "end_at":1626278400}
        """.data(using: .utf8)!
}
