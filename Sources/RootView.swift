import SwiftUI

struct RootView: View {

    @ObservedObject var vm = RootViewModel()
    var body: some View {
        TabView(selection: $vm.tabSelection) {
            VStack {
                CalendarView()
            }
            .tabItem {
                Label(Tabs.calendar.rawValue,
                      systemImage: Tabs.calendar.systemimage)
            }
            .tag(Tabs.calendar)

            ZStack {
                ChannelView()
            }
            .tabItem {
                Label(Tabs.channel.rawValue,
                      systemImage: Tabs.channel.systemimage)
            }
            .tag(Tabs.channel)

            ZStack {
                ReservedView()
            }
            .tabItem {
                Label(Tabs.reserved.rawValue,
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
