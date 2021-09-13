//
//  Channel.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/20.
//

import Foundation

struct Channel: Identifiable, Decodable, Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }

    internal init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    let id: String
    let title: String
}
