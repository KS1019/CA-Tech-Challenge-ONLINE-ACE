import SwiftUI

struct RootView: View {

    @ObservedObject var vm = RootViewModel(repository: TimeTableRepositoryImpl())
    var body: some View {
        TabView(selection: $vm.tabSelection) {
            ZStack {
                CalendarView(vm: vm)
            }
            .tabItem {
                Label(Tabs.calendar.description,
                      systemImage: Tabs.calendar.systemimage)
            }
            .tag(Tabs.calendar)

            ZStack {
                ChannelView()
            }
            .tabItem {
                Label(Tabs.channel.description,
                      systemImage: Tabs.channel.systemimage)
            }
            .tag(Tabs.channel)

            ZStack {
                ReservedView()
            }
            .tabItem {
                Label(Tabs.reserved.description,
                      systemImage: Tabs.reserved.systemimage)
            }
            .tag(Tabs.reserved)

        }
        .onAppear {
            vm.getChannelTimeTable()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
// TODO: 変更項目がなくなれば、別ファイルに移動したい
class RootViewModel: ObservableObject, TimeTableViewModelProtocol {
    @Published var tabSelection = Tabs.calendar
    @Published var searchQuery = ""
    @Published var calendar = ""
    @Published var channelID = ""
    @Published var reserved = false
    @Published var timetables: [TimeTable] = []
    @Published var isEditing = false
    private let repository: TimeTableRepository
    private var subscriptions = Set<AnyCancellable>()

    init(repository: TimeTableRepository) {
        self.repository = repository
        stub(condition: isHost("C.ACE.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("TimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }
    }

    func getChannelTimeTable() {
        self.repository.fetchTimeTableData(channelId: channelID)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")

                case let .failure(error):
                    print(error)
                }

            } receiveValue: { data in
                self.timetables += data
                print(self.timetables)
            }
            .store(in: &self.subscriptions)

    }

}
