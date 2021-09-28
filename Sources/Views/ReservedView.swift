//
//  ReservedView.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/16.
//

import Combine
import SwiftUI

struct ReservedView: View {
    @StateObject var vm: ReservedViewModel = ReservedViewModel(repository: TimeTableRepository(apiProvider: URLSession.shared))
    var body: some View {
        VStack {
            GenreFilterView(selectedGenres: $vm.selectedGenreFilters)

            ScrollView {
                LazyVStack {
                    ForEach(vm.filteredTimeTables) { timetable in
                        VStack(alignment: .leading) {
                            CardView(timeTable: timetable) { programId in
                                vm.deleteReservation(programId: programId)
                            }
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

struct ReservedView_Previews: PreviewProvider {
    static var previews: some View {
        ReservedView()
    }
}
