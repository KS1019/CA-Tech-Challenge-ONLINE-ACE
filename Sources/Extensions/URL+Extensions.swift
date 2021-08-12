//
//  URL+Extensions.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//

import Foundation

extension URL {
    /// クエリを一つ追加した新しいURLを返す
    func queryItemAdded(name: String, value: String?) -> URL? {
        return self.queryItemsAdded([URLQueryItem(name: name, value: value)])
    }

    /// クエリを複数追加した新しいURLを返す.
    /// [URLQueryItem]は自分で定義
    func queryItemsAdded(_ queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: nil != self.baseURL) else {
            return nil
        }
        components.queryItems = queryItems + (components.queryItems ?? [])
        return components.url
    }

}
