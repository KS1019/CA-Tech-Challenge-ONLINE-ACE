//
//  ChannelView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import SwiftUI

struct ChannelView<T: TimeTableViewModelProtocol>: View {
    @StateObject var vm: T
    @State private var selectedIndex: Int = 0
    @State private var selectedGenreFilters: [String: Bool] = [:]
    var body: some View {
        VStack {
            // vmからチャンネル一覧を取得
            HorizontalPickerView(selection: $selectedIndex, selections: vm.channels.map { $0.title })

            GenreFilterView(selectedGenres: $selectedGenreFilters)
                .onAppear {
                    // TODO: 別の場所で管理したい vmとか
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
                        }) { timetable in
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

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(vm: MockTimeTableViewModel())
    }
}
