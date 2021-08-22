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
    @State private var selectedGenreFilters: [String: Bool] = [:]
    var body: some View {
        VStack {
            HorizontalPickerView(selection: $selectedIndex, selections: aWeek ?? [Date()])

            GenreFilterView(selectedGenres: $selectedGenreFilters)
                .onAppear {
                    // TODO: 別の場所で管理したい
                    let labels: [String] = Array(Set(vm.timetables.filter { !$0.labels.isEmpty }.map { $0.labels }.joined()))
                    selectedGenreFilters = labels.reduce([String: Bool]()) { (result, label)  in
                        var newResult = result
                        newResult[label] = false
                        print("newResult \(newResult)")
                        return newResult
                    }
                }

            ScrollView {
                LazyVStack {
                    ForEach(
                        vm.timetables.filter { timetable in
                            timetable.channelId == vm.channels[selectedIndex].id &&
                                (!timetable.labels.filter { label in selectedGenreFilters.filter { dic in dic.value }.keys.sorted().contains(label) }.isEmpty
                                    || !selectedGenreFilters.values.contains(true))
                        }
                    ) { timetable in
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
