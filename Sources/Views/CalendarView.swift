//
//  CalenderView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//
import Combine
import SwiftUI

struct CalendarView: View {
    @StateObject var vm = CalendarViewModel(repository: TimeTableRepository(apiProvider: URLSession.shared))
    var body: some View {
        VStack {
            HorizontalPickerView<DatePickerButtonTrait>(selection: $vm.selectedIndex, selections: vm.aWeek) {
                print("#インデックスが変化しているか\(vm.selectedIndex)")
                vm.onChangeDate()
            }

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(vm.filteredTimeTables) { timetable in
                        VStack(alignment: .leading) {
                            // カードのProgramIdをクロージャーから受け取る
                            CardView(timeTable: timetable, onCommit: { programId in
                                vm.programId = programId
                                vm.alertType = .child

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
        .alert(item: $vm.alertType) {
            switch $0 {
            case .parent:
                return Alert(title: Text(vm.alertMessage))
            case .child:
                return Alert(title: Text("この番組を予約しますか"),
                             primaryButton: .default(
                                Text("予約する"),
                                action: {
                                    vm.postReservedData(vm.programId)
                                    print("Send API Request here")
                                }
                             ),
                             secondaryButton: .cancel())

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
        CalendarView(vm: CalendarViewModel(repository: MockTimeTableRepository(), UUIDRepo: UUIDRepository()))
    }
}
