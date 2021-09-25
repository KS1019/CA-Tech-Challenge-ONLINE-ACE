//
//  ReservedViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class ReservedViewModel<Scheduler: Combine.Scheduler>: TimeTableViewModelProtocol {
    private let userId: String
    private let repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    @Published var timetables: [TimeTable] = []
    @Published var isLoading: Bool = true
    @Published var isAlert: Bool = false
    @Published var selectedGenreFilters: [String: Bool] = [:]
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
    }

    func onAppear() {
        getReservaions()
    }

    func getReservaions() {
        self.repository
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
        self.repository
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
