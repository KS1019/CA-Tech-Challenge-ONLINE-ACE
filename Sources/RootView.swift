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
                Color.green
            }
            .tabItem {
                Label(Tabs.channel.description,
                      systemImage: Tabs.channel.systemimage)
            }
            .tag(Tabs.channel)

            ZStack {
                Color.red
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

enum Tabs: CustomStringConvertible {

    case calendar, channel, reserved

    var description: String {
        switch self {
        case .calendar:
            return "Calendar"
        case .channel:
            return "Channel"
        case .reserved:
            return "Reserved"
        }
    }
    var systemimage: String {
        switch self {
        case .calendar:
            return "calendar"
        case .channel:
            return "square.grid.2x2"
        case .reserved:
            return "alarm"
        }
    }
}
