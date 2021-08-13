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
    var highlight: String { get }
    var detailHighlight: String { get }
    var startAt: Int { get }
    var endAt: Int { get }
    var channelId: String { get }
    var labels: [String: Bool] { get }
}

struct TimeTableResult: Decodable {
    let data: [TimeTable]
}

struct TimeTable: Decodable, Identifiable, Equatable {
    let id: String
    let title: String
    let highlight: String
    let detailHighlight: String
    let startAt: Int
    let endAt: Int
    let channelId: String
    let labels: [String: Bool]
    let displayProgram: DisplayProgram
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
