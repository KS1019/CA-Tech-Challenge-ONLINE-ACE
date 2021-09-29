//
//  Date+Extensions.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Foundation

extension Calendar {
    static let shared = Calendar(identifier: .gregorian)
    static var aWeek: [Date] {
        // swiftlint:disable force_unwrapping
        let today = shared.date(from: DateComponents(year: 2_021, month: 7, day: 22))!
        return (-2 ..< 7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }
}
