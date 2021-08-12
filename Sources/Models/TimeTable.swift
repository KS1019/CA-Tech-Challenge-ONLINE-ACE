//
//  TimeTable.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Foundation

struct TimeTableResult: Decodable {
    let data: [TimeTable]
}

struct TimeTable: Decodable, Identifiable {
    let id: String
    let title: String
    let startAt: Int
    let endAt: Int
    let channelId: String
    let labels: [String:Bool]
}
