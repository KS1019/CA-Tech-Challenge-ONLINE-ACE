//
//  ReservedViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ReservedViewModel: TimeTableViewModelProtocol {
    private let repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    @Published var timetables: [TimeTable] = []
    @Published var isLoading: Bool = true
    @Published var selectedGenreFilters: [String: Bool] = [:]

    init(repository: TimeTableRepositoryProtocol) {
        self.repository = repository
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
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false
                case let .failure(error):
                    print(error)
                    self.isLoading = true
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
            // swiftlint:disable force_try
            try! UUIDRepository().register(uuid: uuid)
        }
        self.repository
            .deleteReservationData(userId: uuidStr, programId: programId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false
                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }
            } receiveValue: {
            }
            .store(in: &self.subscriptions)

    }
}
