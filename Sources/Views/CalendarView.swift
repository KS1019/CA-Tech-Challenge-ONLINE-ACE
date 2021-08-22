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
            HorizontalPickerView(selection: $vm.selectedIndex, selections: vm.aWeek)

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(
                        vm.timetables.filter { timetable in
                            ((vm.aWeek[vm.selectedIndex] <= Date(timeIntervalSince1970: TimeInterval(timetable.startAt))
                                && Date(timeIntervalSince1970: TimeInterval(timetable.startAt)) <= vm.aWeek[vm.selectedIndex])
                                || (vm.aWeek[vm.selectedIndex] <= Date(timeIntervalSince1970: TimeInterval(timetable.endAt))
                                        && Date(timeIntervalSince1970: TimeInterval(timetable.endAt)) <= vm.aWeek[vm.selectedIndex]))
                                && (!timetable.labels.filter { label in
                                    vm.selectedGenreFilters.filter { dic in dic.value }.keys.sorted().contains(label)
                                }.isEmpty || !vm.selectedGenreFilters.values.contains(true))
                        }) { timetable in
                        VStack(alignment: .leading) {
                            CardView(timeTable: timetable)
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

    private let repository: TimeTableRepository
    private var subscriptions = Set<AnyCancellable>()
    var timetables: [TimeTable] = []

    @Published var selectedIndex: Int = 0
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var isLoading: Bool = true
    @Published var channels: [Channel] = []
    @Published var labels: [String] = []
    var aWeek: [Date] = Date.aWeek ?? [Date()]

    init(repository: TimeTableRepository) {
        self.repository = repository
    }

    func onAppear() {
        getTimeTableData(firstAt: 0, lastAt: 0, channelId: nil, labels: nil)
        getChannelData()

        labels = Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
        selectedGenreFilters = labels.reduce([String: Bool]()) { (result, label)  in
            var newResult = result
            newResult[label] = false
            return newResult

        }
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        let selectTimestamp = Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!)
        repository.fetchTimeTableData(firstAt: 1_626_238_800, lastAt: 1_626_238_800 + 86_400, channelId: nil, labels: nil)
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
                print("calendarview:\(self.timetables)")
            }
            .store(in: &self.subscriptions)
    }

    func getChannelData() {
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("CalendarViewModelのデータ取得成功 \(#function)")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.channels += data
                print("calendarview:\(self.channels)")
            }
            .store(in: &self.subscriptions)
    }

}

extension Date {
    static var aWeek: [Date]? = Date.getWeek()

    static func getWeek() -> [Date]? {
        var aWeek: [Date] = []
        let today = Date()
        for i in -2..<7 {
            guard let day = Calendar.current.date(byAdding: .day, value: i, to: today) else { return nil }
            aWeek.append(day)
        }
        return aWeek
    }
}
