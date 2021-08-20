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
    var body: some View {
        VStack {
            // vmからチャンネル一覧を取得
            HorizontalPickerView(selection: $selectedIndex, selections: vm.channels.map { $0.title })

            ScrollView {
                LazyVStack {
                    ForEach(vm.timetables.filter { $0.channelId == vm.channels[selectedIndex].id }) { timetable in
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
