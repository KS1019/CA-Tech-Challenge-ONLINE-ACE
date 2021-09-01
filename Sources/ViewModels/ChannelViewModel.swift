//
//  ChannelViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ChannelViewModel: TimeTableViewModelProtocol {
    var userId: String
    private(set) var repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    var timetables: [TimeTable] = []
    @Published var channels: [Channel] = []
    @Published var selectedIndex: Int = 0
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var filteredTimetables: [TimeTable] = []

    @Published var isLoading: Bool = true
    @Published var reservedFlag = false
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

    func reloadData() {
        let labelsLoaded = Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
        if labelsLoaded.sorted() != labels.sorted() {
            labels = Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
            selectedGenreFilters = labels.reduce([String: Bool]()) { (result, label)  in
                var newResult = result
                newResult[label] = false
                return newResult
            }
        }
    }

    func onAppear() {
        getChannelData()
        getTimeTableData(firstAt: 1_626_238_800, lastAt: 1_626_238_800 + 86_400, channelId: nil, labels: nil)
        reloadData()
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        let selectTimestamp = Int((Calendar.aWeek?[selectedIndex].timeIntervalSince1970)!)
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
                self.timetables = data
                self.reloadData()
            }
            .store(in: &self.subscriptions)

    }

    func getChannelData() {
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("CalendarViewModelのデータ取得成功\(#function)")
                    self.isLoading = false
                    self.reloadData()
                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.channels += data
            }
            .store(in: &self.subscriptions)
    }

    func postReservedData(_ programId: String) {
        repository.postReservationData(userId: userId, programId: programId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Post成功")
                    // 紫のエラー Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
                    self.reservedFlag = true
                    self.reloadData()
                case let .failure(error):
                    print(error)
                    self.reservedFlag = false
                }

            } receiveValue: {
            }
            .store(in: &self.subscriptions)
    }
}
