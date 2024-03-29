//
//  ChannelViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ChannelViewModel<Scheduler: Combine.Scheduler>: ObservableObject {
    private let userId: String
    private(set) var repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    @Published var timetables: [TimeTable] = []
    @Published var channels: [Channel] = []
    @Published var selectedIndex: Int = 0
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var isLoading: Bool = true
    @Published var reservedFlag = false

    @Published var filteredTimeTables: [TimeTable] = []
    private let scheduler: Scheduler

    init(repository: TimeTableRepositoryProtocol, UUIDRepo: UUIDRepositoryProtocol = UUIDRepository(), scheduler: Scheduler) {
        self.repository = repository
        do {
            userId = try UUIDRepo.fetchUUID()
        } catch {
            let uuid = UUID()
            userId = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepo.register(uuid: uuid)
        }

        self.scheduler = scheduler

        setupPublishers()
    }

    private func setupPublishers() {
        Publishers.CombineLatest3(
            $timetables,
            $channels,
            Publishers.CombineLatest(
                $selectedGenreFilters,
                $selectedIndex)
        )
        .map { timetables, channels, selection -> [TimeTable] in
            let selectedGenreFilters = selection.0
            let selectedIndex = selection.1
            return timetables.filter { timetable in
                !channels.isEmpty
                    && timetable.channelId == channels[selectedIndex].id
                    && (!timetable.labels.filter { label in
                        selectedGenreFilters.filter { dic in dic.value }.keys.sorted().contains(label)
                    }.isEmpty
                    || !selectedGenreFilters.values.contains(true))
            }
        }
        .assign(to: &$filteredTimeTables)

        $timetables
            .map { timetables -> [String] in
                Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
            }
            .combineLatest($labels)
            .filter { labelsLoaded, labels in
                labelsLoaded.sorted() != labels.sorted()
            }
            .map { labelsLoaded, _ -> [String: Bool] in
                self.labels = labelsLoaded
                return labelsLoaded.reduce([String: Bool]()) { (result, label)  in
                    var newResult = result
                    newResult[label] = false
                    return newResult
                }
            }
            .assign(to: &$selectedGenreFilters)
    }

    func onAppear() {
        getChannelData()
        getTimeTableData(firstAt: Int(Calendar.aWeek[selectedIndex].timeIntervalSince1970),
                         lastAt: Int(Calendar.aWeek[selectedIndex].timeIntervalSince1970) + 86_400,
                         channelId: nil, labels: nil)
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        repository.fetchTimeTableData(firstAt: firstAt, lastAt: lastAt, channelId: nil, labels: nil)
            .receive(on: scheduler)
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
            }
            .store(in: &self.subscriptions)

    }

    func getChannelData() {
        repository.fetchChannelData()
            .receive(on: scheduler)
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
                self.channels = data
            }
            .store(in: &self.subscriptions)
    }

    func postReservedData(_ programId: String) {
        repository.postReservationData(reservationData: ReservationData(userId: userId, programId: programId))
            .receive(on: scheduler)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Post成功")
                    self.reservedFlag = true
                case let .failure(error):
                    print(error)
                    self.reservedFlag = false
                }

            } receiveValue: { error in
                print(error as Any)
            }
            .store(in: &self.subscriptions)
    }
}

extension ChannelViewModel where Scheduler == DispatchQueue {
    convenience init(
        repository: TimeTableRepositoryProtocol,
        UUIDRepo: UUIDRepositoryProtocol = UUIDRepository()
    ) {
        self.init(
            repository: repository,
            UUIDRepo: UUIDRepo,
            scheduler: DispatchQueue.main
        )
    }
}
