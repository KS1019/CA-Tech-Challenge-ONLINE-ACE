//
//  ChannelView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//
import Combine
import SwiftUI

struct ChannelView: View {
    @StateObject var vm = ChannelViewModel(repository: TimeTableRepositoryImpl())
    var body: some View {
        VStack {
            // vmからチャンネル一覧を取得
            HorizontalPickerView(selection: $vm.selectedIndex, selections: vm.channels.map { $0.title })

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(
                        vm.timetables.filter { timetable in
                            !vm.channels.isEmpty
                                && timetable.channelId == vm.channels[vm.selectedIndex].id
                                && (!timetable.labels.filter { label in
                                    vm.selectedGenreFilters.filter { dic in dic.value }.keys.sorted().contains(label)
                                }.isEmpty
                                || !vm.selectedGenreFilters.values.contains(true))
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
}
private var activityIndicator: some View {
    ActivityIndicator(style: .medium)
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(vm: ChannelViewModel(repository: TimeTableRepositoryImpl()))
    }
}

class ChannelViewModel: TimeTableViewModelProtocol {

    private let repository: TimeTableRepository
    private var subscriptions = Set<AnyCancellable>()
    @Published var labels: [String] = []
    var timetables: [TimeTable] = []
    @Published var channels: [Channel] = []
    @Published var selectedIndex: Int = 0
    @Published var selectedGenreFilters: [String: Bool] = [:]
    @Published var filteredTimetables: [TimeTable] = []
    // private(set)にしたいがTimeTableViewModelProtocolを継承しておりprivateを宣言できない
    @Published var isLoading: Bool = true
    init(repository: TimeTableRepository) {
        self.repository = repository
    }

    func onAppear() {
        getChannelData()
        getTimeTableData(firstAt: 1_626_238_800, lastAt: 1_626_238_800 + 86_400, channelId: nil, labels: nil)

        labels = Array(Set(timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
        selectedGenreFilters = labels.reduce([String: Bool]()) { (result, label)  in
            var newResult = result
            newResult[label] = false
            return newResult

        }
    }

    func getTimeTableData(firstAt: Int, lastAt: Int, channelId: String?, labels: String?) {
        let selectTimestamp = Int((Date.aWeek?[selectedIndex].timeIntervalSince1970)!)
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
                self.timetables += data
                print("calendarview:\(self.timetables)")
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
