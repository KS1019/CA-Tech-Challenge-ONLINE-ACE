//
//  Tabs.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import Foundation

enum Tabs: CustomStringConvertible {
    
    case calendar, channel, reserved
    
    var description: String {
        switch self {
        case .calendar:
            return "Calendar"
        case .channel:
            return "Channel"
        case .reserved:
            return "Reserved"
        }
    }
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
