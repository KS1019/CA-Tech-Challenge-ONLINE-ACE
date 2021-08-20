//
//  CalenderView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import SwiftUI

struct CalendarView<T: TimeTableViewModelProtocol>: View {
    @StateObject var vm: T
    @State var aWeek: [Date]? = Date.getWeek()
    @State private var selectedIndex: Int = 0
    var body: some View {
        VStack {
            HorizontalPickerView(selection: $selectedIndex, selections: aWeek ?? [Date()])

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables) { timetable in
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
    }
    private var activityIndicator: some View {
        ActivityIndicator(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }

}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(vm: MockTimeTableViewModel())
    }
}

extension Date {
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
