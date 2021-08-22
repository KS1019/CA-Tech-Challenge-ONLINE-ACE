//
//  Date+Extensions.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Foundation

extension Date {
    static var aWeek: [Date]? = Date.getWeek()

    static func getWeek() -> [Date] {
        var aWeek: [Date] = []
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.date(from: DateComponents(year: 2_021, month: 7, day: 22))!
        for i in -2..<7 {
            if let day = Calendar.current.date(byAdding: .day, value: i, to: today) {
                aWeek.append(day)
            }

        }
        return aWeek
    }
}
