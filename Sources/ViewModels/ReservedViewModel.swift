//
//  ReservedViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ReservedViewModel: TimeTableViewModelProtocol {
    let userId: String
    private let repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    @Published var timetables: [TimeTable] = []
    @Published var isLoading: Bool = true
    @Published var isAlert: Bool = false
    @Published var selectedGenreFilters: [String: Bool] = [:]

    init(repository: TimeTableRepositoryProtocol, UUIDRepo: UUIDRepositoryProtocol = UUIDRepository()) {
        self.repository = repository
        do {
            userId = try UUIDRepo.fetchUUID()
        } catch {
            let uuid = UUID()
            userId = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepo.register(uuid: uuid)
        }
    }

    func onAppear() {
        getReservaions()
        labels = Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
        selectedGenreFilters = labels.reduce([String: Bool]()) { (result, label)  in
            var newResult = result
            newResult[label] = false
            return newResult

        }
    }

    func reload() {
        getReservaions()
    }

    func getReservaions() {
        var uuidStr: String
        do {
            uuidStr = try UUIDRepository().fetchUUID()
        } catch {
            let uuid = UUID()
            uuidStr = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepository().register(uuid: uuid)
        }
        self.repository
            .fetchReservationData(userId: uuidStr.lowercased())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
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
        var uuidStr: String
        do {
            uuidStr = try UUIDRepository().fetchUUID()
        } catch {
            let uuid = UUID()
            uuidStr = uuid.uuidString

            try! UUIDRepository().register(uuid: uuid)
        }
        self.repository
            .deleteReservationData(userId: uuidStr, programId: programId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false
                    self.reload()
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
