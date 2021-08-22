//
//  CalendarViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class CalendarViewModel: TimeTableViewModelProtocol {
    var userId: String
    private let repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    var timetables: [TimeTable] = []

    @Published var reservedFlag = false
    @Published var selectedIndex: Int = 2
    @Published var isLoading: Bool = true
    @Published var channels: [Channel] = []
    @Published var labels: [String] = []
    @Published var selectedGenreFilters: [String: Bool] = [:]
    var aWeek: [Date] = Date.aWeek ?? [Date()]

    init(repository: TimeTableRepositoryProtocol) {
        self.repository = repository
        do {
            userId = try UUIDRepository().fetchUUID()
        } catch {
            let uuid = UUID()
            userId = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepository().register(uuid: uuid)
        }
    }

    func onAppear() {
        getTimeTableData(firstAt: Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!), lastAt: Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!) + 86_400, channelId: nil, labels: nil)

    }

    func onChangeDate() {
        getTimeTableData(firstAt: Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!), lastAt: Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!) + 86_400, channelId: nil, labels: nil)
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        repository.fetchTimeTableData(firstAt: firstAt, lastAt: lastAt, channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished:
                    print("CalendarViewModelのデータ取得成功\(#function)")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.timetables = data.sorted { $0.startAt < $1.startAt }
                print("calendarview:\(self.timetables)")
            }
            .store(in: &self.subscriptions)
    }

    func postReservedData(_ programId: String) {
        repository.postReservationData(userId: userId, programId: programId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Post成功")
                case let .failure(error):
                    print(error)

                }

            } receiveValue: {
            }
            .store(in: &self.subscriptions)
    }

}
