//
//  TimeTableViewModelProtocol.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Foundation

protocol TimeTableViewModelProtocol: ObservableObject {
    associatedtype ListData: TimeTableProtocol
    var timetables: [ListData] { get set }
    var isLoading: Bool { get set }
}
