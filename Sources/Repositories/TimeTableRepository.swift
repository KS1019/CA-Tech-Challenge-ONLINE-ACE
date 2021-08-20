//
//  TimeTableRepository.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Combine
import Foundation

protocol TimeTableRepository {
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error>
    func fetchChannelsData() -> AnyPublisher<[ChannelModelImpl], Error>
}

class TimeTableRepositoryImpl: TimeTableRepository {
    func fetchTimeTableData(channelId: String) -> AnyPublisher<[TimeTable], Error> {

        // swiftlint:disable force_unwrapping
        let url = TimeTableRepositoryImpl.baseURL.queryItemAdded(name: "channelId", value: channelId)!
        print(url)
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { try
                JSONDecoder().decode(TimeTableResult.self, from: $0.data).data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchChannelsData() -> AnyPublisher<[ChannelModelImpl], Error> {
        let url = URL(string: "https://api.c.ace2108.net/api/v1/channel")!

        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap {
                try JSONDecoder().decode(ChannelResult.self, from: $0.data).channels
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension TimeTableRepositoryImpl {
    static let baseURL = URL(string: "https://C.ACE.ace-c-ios/projects")!

}
