//
//  CalenderView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//
import Combine
import SwiftUI

struct CalendarView: View {
    @StateObject var vm = CalendarViewModel(repository: TimeTableRepository(), UUIDRepo: UUIDRepository())
    var body: some View {
        VStack {
            HorizontalPickerView(selection: $vm.selectedIndex, selections: vm.aWeek) {
                print("#インデックスが変化しているか\(vm.selectedIndex)")
                vm.onChangeDate()
            }

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables) { timetable in
                        VStack(alignment: .leading) {
                            // カードのProgramIdをクロージャーから受け取る
                            CardView(timeTable: timetable, onCommit: { programId in
                                vm.postReservedData(programId)
                            })

                        }
                    }
                }
                if vm.isLoading {
                    activityIndicator
                }
            }

        }
        .onAppear(perform: vm.onAppear)
    }
    private var activityIndicator: some View {
        ActivityIndicator(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }

}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(vm: CalendarViewModel(repository: MockTimeTableRepository(), UUIDRepo: UUIDRepository()))
    }
}
