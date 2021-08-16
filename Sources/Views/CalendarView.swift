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
    var body: some View {
        VStack {
            SearchBar(query: $vm.searchQuery, isEditing: $vm.isEditing) {
                print("検索")
            }

            HorizontalPickerView(selections: aWeek ?? [Date()])
                .previewLayout(.sizeThatFits)

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables) { timetable in
                        VStack(alignment: .leading) {
                            CardView(timeTable: timetable)
                        }
                    }
                }
            }

        }
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
