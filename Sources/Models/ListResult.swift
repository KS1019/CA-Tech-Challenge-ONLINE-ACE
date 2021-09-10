//
//  ListResult.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/09/10.
//

import Foundation

struct ListResult<T: Decodable>: Decodable {
    var programs: [T]?
    var channels: [T]?
    // Channel は　channels
    // TimeTableは programsとなっていて、itemsの名前が異なるためまとめることができない。
}
