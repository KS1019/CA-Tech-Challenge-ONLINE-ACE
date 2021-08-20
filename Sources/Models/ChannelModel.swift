//
//  ChannelModel.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/20.
//

import Foundation

protocol ChannelModel: Identifiable, Decodable {
    var id: String { get }
    var title: String { get }
}

struct ChannelModelImpl: ChannelModel {
    let id: String
    let title: String
}

struct ChannelResult: Decodable {
    let channels: [ChannelModelImpl]
}
