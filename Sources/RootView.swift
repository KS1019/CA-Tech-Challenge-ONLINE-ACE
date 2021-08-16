import SwiftUI

struct RootView: View {

    @ObservedObject var vm = RootViewModel()
    var body: some View {
        TabView(selection: $vm.tabSelection) {

            ZStack {
                CalendarView()
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
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

// TODO: 変更項目がなくなれば、別ファイルに移動したい
class RootViewModel: ObservableObject {
    @Published var tabSelection = Tabs.calendar
}
