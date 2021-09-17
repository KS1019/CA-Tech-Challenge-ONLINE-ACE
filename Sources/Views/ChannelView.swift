//
//  ChannelView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//
import Combine
import SwiftUI

struct ChannelView: View {
    @StateObject var vm = ChannelViewModel(repository: TimeTableRepository(apiProvider: URLSession.shared))
    var body: some View {
        VStack {
            // vmからチャンネル一覧を取得
            HorizontalPickerView(selection: $vm.selectedIndex, selections: vm.channels.map { $0.title }) {
                print("フィルターボタンをタップ")
            }

            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(vm.filteredTimetables) { timetable in
                        VStack(alignment: .leading) {
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
}
private var activityIndicator: some View {
    ActivityIndicator(style: .medium)
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(vm: ChannelViewModel(repository: TimeTableRepository(apiProvider: MockAPIProvider())))
    }
}
