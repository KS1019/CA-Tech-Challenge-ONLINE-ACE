import SwiftUI

struct RootView: View {

    @ObservedObject var vm = RootViewModel(repository: MockTimeTableRepositoryImpl())
    var body: some View {
        TabView(selection: $vm.tabSelection) {
            VStack {
                CalendarView(vm: vm)
            }
            .tabItem {
                Label(Tabs.calendar.description,
                      systemImage: Tabs.calendar.systemimage)
            }
            .tag(Tabs.calendar)

            ZStack {
                ChannelView(vm: vm)
            }
            .tabItem {
                Label(Tabs.channel.description,
                      systemImage: Tabs.channel.systemimage)
            }
            .tag(Tabs.channel)

            ZStack {
                ReservedView(vm: vm)
            }
            .tabItem {
                Label(Tabs.reserved.description,
                      systemImage: Tabs.reserved.systemimage)
            }
            .tag(Tabs.reserved)

        }
        .onAppear {
            vm.getChannelTimeTable()
            vm.getChannels()
            vm.getReservaions()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

import Combine

// TODO: 変更項目がなくなれば、別ファイルに移動したい
class RootViewModel: ObservableObject, TimeTableViewModelProtocol {
    @Published var tabSelection = Tabs.calendar
    @Published var searchQuery = ""
    @Published var calendar = ""
    @Published var channelID = ""
    @Published var reserved = false
    @Published var timetables: [TimeTable] = []
    @Published var isEditing = false
    @Published var isLoading = true
    @Published var channels: [Channel] = []
    @Published var reservations: [TimeTable] = []
    private let repository: TimeTableRepository
    private var channelList: [Channel] = []
    private var subscriptions = Set<AnyCancellable>()

    init(repository: TimeTableRepository) {
        self.repository = repository
    }

    func getChannelTimeTable() {
        self.repository.fetchTimeTableData(channelId: channelID)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.timetables += data
                print(self.timetables)
            }
            .store(in: &self.subscriptions)
    }

    func getChannels() {
        self.repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }
            } receiveValue: { channels in
                self.channels = channels
            }
            .store(in: &self.subscriptions)

    }

    func getChannelList() {
        self.repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")
                    self.isLoading = false

                case let .failure(error):
                    print(error)
                    self.isLoading = true
                }

            } receiveValue: { data in
                self.channelList += data
                print(self.timetables)
            }
            .store(in: &self.subscriptions)
    }

    func getReservaions() {
        var uuidStr: String
        do {
            uuidStr = try UUIDRepositoryImpl().fetchUUID()
        } catch {
            let uuid = UUID()
            uuidStr = uuid.uuidString
            // swiftlint:disable force_try
            try! UUIDRepositoryImpl().register(uuid: uuid)
        }
        //        self.repository
        //            .fetchReservations(userId: uuidStr)
        //            .sink { completion in
        //                switch completion {
        //                case .finished:
        //                    print("終了コード")
        //                    self.isLoading = false
        //                case let .failure(error):
        //                    print(error)
        //                    self.isLoading = true
        //                }
        //            } receiveValue: { (data) in
        //                self.reservations = data
        //            }
        //            .store(in: &self.subscriptions)
    }
}
