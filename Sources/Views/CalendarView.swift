//
//  CalenderView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import SwiftUI

struct CalendarView<T: TimeTableViewModelProtocol>: View {
    @ObservedObject var vm: T
    var body: some View {
        VStack {
            SearchBar(query: $vm.searchQuery, isEditing: $vm.isEditing) {
                print("検索")
            }

            List(vm.timetables) { timetable in
                CardView(timeTable: timetable)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        var timetables: [MockTimeTable] = [MockTimeTable].init(repeating: MockTimeTable(), count: 20)
        CalendarView(vm: MockTimeTableViewModel())
    }
}
