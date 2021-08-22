//
//  CalenderView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//
import Combine
import SwiftUI

struct CalendarView: View {
    @StateObject var vm = CalendarViewModel(repository: TimeTableRepositoryImpl())
    var body: some View {
        VStack {
            HorizontalPickerView(selection: $vm.selectedIndex, selections: vm.aWeek) {
                print("#インデックスが変化しているか\(vm.selectedIndex)")
                vm.onChangeDate()
            }

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables) { timetable in
                        VStack(alignment: .leading) {
                            // カードのProgramIdをクロージャーから受け取る
                            CardView(timeTable: timetable, onCommit: { programId in
                                vm.postReservedData(programId)
                            })

                        }
                    }
                }
                if vm.isLoading {
                    activityIndicator
                }
            }

        }
        .onAppear(perform: vm.onAppear)
    }
    private var activityIndicator: some View {
        ActivityIndicator(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }

}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(vm: CalendarViewModel(repository: MockTimeTableRepositoryImpl()))
    }
}

class CalendarViewModel: TimeTableViewModelProtocol {
    var userId: String
    private let repository: TimeTableRepository
    private var subscriptions = Set<AnyCancellable>()
    var timetables: [TimeTable] = []

    @Published var reservedFlag = false
    @Published var selectedIndex: Int = 2
    @Published var isLoading: Bool = true
    @Published var channels: [Channel] = []
    @Published var labels: [String] = []
    @Published var selectedGenreFilters: [String: Bool] = [:]
    var aWeek: [Date] = Date.aWeek ?? [Date()]

    init(repository: TimeTableRepository) {
        self.repository = repository
        do {
            userId = try UUIDRepositoryImpl().fetchUUID()
        } catch {
            let uuid = UUID()
            userId = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepositoryImpl().register(uuid: uuid)
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

extension Date {
    static var aWeek: [Date]? = Date.getWeek()

    static func getWeek() -> [Date] {
        var aWeek: [Date] = []
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.date(from: DateComponents(year: 2_021, month: 7, day: 22))!
        for i in -2..<7 {
            if let day = Calendar.current.date(byAdding: .day, value: i, to: today) {
                aWeek.append(day)
            }

        }
        return aWeek
    }
}
