//
//  ReservedViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ReservedViewModel<Scheduler: Combine.Scheduler>: ObservableObject {
    @Published var timetables: [TimeTable] = []
    @Published var isLoading: Bool = true
    @Published var isAlert: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    private let repository: TimeTableRepositoryProtocol
    private let scheduler: Scheduler
    private let userId: String

    @Published private var labels: [String] = []
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var filteredTimeTables: [TimeTable] = []
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
        Publishers.CombineLatest(
            $timetables,
            $selectedGenreFilters
        )
        .map { timetables, selectedGenreFilters in
            return timetables.filter { timetable in
                (!timetable.labels.filter { label in
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
        getReservaions()
    }

    func getReservaions() {
        repository
            .fetchReservationData(userId: userId.lowercased())
            .receive(on: scheduler)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    print(error)
                    self.isLoading = true
                    self.isAlert = true
                }
            } receiveValue: { (data) in
                self.timetables = data
            }
            .store(in: &self.subscriptions)
    }

    func deleteReservation(programId: String) {
        repository
            .deleteReservationData(userId: userId.lowercased(), programId: programId)
            .receive(on: scheduler)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false
                    self.getReservaions()
                    self.isAlert = false
                case let .failure(error):
                    print(error)
                    self.isLoading = true
                    self.isAlert = true
                }
            } receiveValue: {
            }
            .store(in: &self.subscriptions)

    }
}

extension ReservedViewModel where Scheduler == DispatchQueue {
    convenience init(repository: TimeTableRepositoryProtocol, UUIDRepo: UUIDRepositoryProtocol = UUIDRepository()) {
        self.init(repository: repository, UUIDRepo: UUIDRepo, scheduler: DispatchQueue.main)
    }
}
