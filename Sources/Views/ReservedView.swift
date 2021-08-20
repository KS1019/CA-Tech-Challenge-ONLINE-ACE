//
//  ReservedView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import SwiftUI

struct ReservedView<T: TimeTableViewModelProtocol>: View {
    @StateObject var vm: T
    @State var aWeek: [Date]? = Date.getWeek()
    @State private var selectedIndex: Int = 0
    var body: some View {
        VStack {
            HorizontalPickerView(selection: $selectedIndex, selections: aWeek ?? [Date()])

            ScrollView {
                LazyVStack {
                    ForEach(vm.reservations.filter {
                                aWeek![selectedIndex] <= Date(timeIntervalSince1970: TimeInterval($0.startAt)) ||
                                Date(timeIntervalSince1970: TimeInterval($0.endAt)) <= aWeek![selectedIndex] })
                    { timetable in
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

struct ReservedView_Previews: PreviewProvider {
    static var previews: some View {
        ReservedView(vm: MockTimeTableViewModel())
    }
}
