//
//  TimeTable.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Foundation

protocol TimeTableProtocol: Identifiable, Decodable {
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

struct TimeTableResult: Decodable {
    let programs: [TimeTable]
}

struct TimeTable: TimeTableProtocol, Equatable {

    let id: String
    let title: String
    let highlight: String
    let detailHighlight: String
    let startAt: Int
    let endAt: Int
    let channelId: String
    let labels: [String]
    let content: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case highlight
        case detailHighlight = "detail_highlight"
        case startAt = "start_at"
        case endAt = "end_at"
        case channelId = "channel_id"
        case labels
        case content
    }

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
