import SwiftUI

struct RootView: View {
    @State var tabSelection: Tabs = Tabs.calendar
    var body: some View {
        TabView(selection: $tabSelection) {

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
