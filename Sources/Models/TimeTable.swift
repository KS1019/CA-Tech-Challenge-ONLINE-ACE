//
//  TimeTable.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Foundation

protocol TimeTableProtocol: Identifiable, Decodable, Equatable {
    var id: String { get }
    var title: String { get }
    var channelId: String { get }
    var labels: [String] { get }
    var highlight: String { get }
    var detailHighlight: String { get }
    var content: String { get }
    var startAt: Int { get }
    var endAt: Int { get }
}

struct ListResult<T: Decodable>: Decodable {
    var programs: [T]?
    var channels: [T]?
    // Channel は　channels
    // TimeTableは programsとなっていて、itemsの名前が異なるためまとめることができない。
}

struct TimeTableResult: Decodable {
    let programs: [TimeTable]
}

struct TimeTable: TimeTableProtocol {

    let id: String
    let title: String
    let highlight: String
    let detailHighlight: String
    let startAt: Int
    let endAt: Int
    let channelId: String
    let labels: [String]
    let content: String

}

struct DisplayProgram: Decodable, Equatable {
    struct Credit: Decodable, Equatable {
        let casts: [String]
        let crews: [String]
        let copyrights: [String]
    }
    let credit: Credit
    let content: String
}

// FBからの修正

extension TimeTable {
    static func mock() -> TimeTable {
        return TimeTable(
            id: UUID().uuidString,
            title: "ENLIGHT #1",
            highlight: "Test Highlight",
            detailHighlight: "Test detailHighlight",
            startAt: 1_627_232_880,
            endAt: 1_627_237_860,
            channelId: "fishing",
            labels: ["live", "now"],
            content: "「いつも通り、目一杯釣るだけ! 簡単にはいかないと思いますが、苦しむ僕を見てください!」と話す 日本最高レベルの岸釣りアングラー川村光大郎の新番組『ENLIGHT』初回は霞ケ浦の流入河川で40UPを狙う!"
        )
    }
}
