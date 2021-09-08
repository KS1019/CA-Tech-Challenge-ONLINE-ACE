//
//  Tabs.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import Foundation

enum Tabs: String {

    case calendar = "Calendar"
    case channel = "Channel"
    case reserved = "Reserved"

    var systemimage: String {
        switch self {
        case .calendar:
            return "calendar"
        case .channel:
            return "square.grid.2x2"
        case .reserved:
            return "alarm"
        }
    }
}
