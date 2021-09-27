//
//  CalendarViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/22.
//

import Combine
import Foundation

class CalendarViewModel<Scheduler: Combine.Scheduler>: TimeTableViewModelProtocol {
    private let userId: String
    private let repository: TimeTableRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var alertType: AlertType?
    @Published var alertMessage = ""
    @Published var showingAlert = false
    @Published var timetables: [TimeTable] = []

    @Published var reservedFlag = false
    @Published var selectedIndex: Int = 2
    @Published var isLoading: Bool = true
    @Published var channels: [Channel] = []
    @Published var labels: [String] = []
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var programId = ""
    let aWeek: [Date] = Calendar.aWeek
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
        getTimeTableData(firstAt: Int(Calendar.aWeek[selectedIndex].timeIntervalSince1970),
                         lastAt: Int(Calendar.aWeek[selectedIndex].timeIntervalSince1970) + 86_400,
                         channelId: nil, labels: nil)
    }

    func onChangeDate() {
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
                self.timetables = data.sorted { $0.startAt < $1.startAt }
                print("calendarview:\(self.timetables)")
            }
            .store(in: &self.subscriptions)
    }

    func postReservedData(_ programId: String) {
        repository.postReservationData(reservationData: ReservationData(userId: userId, programId: programId))
            .receive(on: scheduler)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Post成功")
                case let .failure(error):
                    print(error)

                }

            } receiveValue: { error in
                if let error = error {
                    print(error.code)
                    self.showingAlert = true
                    self.alertMessage = error.error
                    self.alertType = .parent
                }
            }
            .store(in: &self.subscriptions)
    }

}

extension CalendarViewModel where Scheduler == DispatchQueue {
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

enum AlertType: Int, Identifiable {
    case parent = 1
    case child = 2

    var id: Int {
        rawValue
    }
}
