//
//  ListResult.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/09/10.
//

import Foundation

struct ListResult<T: ListResultItem>: Decodable {
    let items: [T]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ListResultKey.self)
        items = try container.decode([T].self, forKey: T.key)
    }
}

protocol ListResultItem: Decodable {
    static var key: ListResultKey { get }
}

// デコード・エンコード可能な新しいキーを作成
struct ListResultKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

extension TimeTable: ListResultItem {
    static var key: ListResultKey {
        .init(stringValue: "programs")
    }
}

extension Channel: ListResultItem {
    static var key: ListResultKey {
        .init(stringValue: "channels")
    }
}
