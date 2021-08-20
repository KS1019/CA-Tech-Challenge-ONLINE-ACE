//
//  Channel.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/20.
//

import Foundation

struct ChannelListResult: Decodable {
    let channels: [Channel]
}

struct Channel: Identifiable, Decodable, Hashable {
    let id: String
    let title: String
}
