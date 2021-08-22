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
            HorizontalPickerView(selection: $vm.selectedIndex, selections: Date.aWeek ?? [Date()])

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables) { timetable in
                        VStack(alignment: .leading) {
                            //カードのProgramIdをクロージャーから受け取る
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
    let userId = UUID().uuidString.lowercased()
    private let repository: TimeTableRepository
    private var subscriptions = Set<AnyCancellable>()
    var timetables: [TimeTable] = []
    @Published var reservedFlag = false
    @Published var selectedIndex: Int = 2
    @Published var isLoading: Bool = true

    init(repository: TimeTableRepository) {
        self.repository = repository
    }

    func onAppear() {
        getTimeTableData(firstAt: 0, lastAt: 0, channelId: nil, labels: nil)
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        let selectTimestamp = Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!)
        repository.fetchTimeTableData(firstAt: 1_626_238_800, lastAt: 1_626_238_800 + 86_400, channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished:
                    print("CalendarViewModelのデータ取得成功")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.timetables += data
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
                    //紫のエラー Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
                    self.reservedFlag = true

                case let .failure(error):
                    print(error)
                    self.reservedFlag = false
                }

            } receiveValue: {
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
