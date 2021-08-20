//
//  MockAPIView.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Combine
import SwiftUI

// MARK: モック用のViewModel [TimeTable]()を使える
class MockTimeTableViewModel: TimeTableViewModelProtocol {
    @Published var channels: [ChannelModelImpl] = []

    func getChannelTimeTable() {
        timetables = [MockTimeTable].init(repeating: MockTimeTable(), count: Int.random(in: 1 ... 5))
    }

    @Published var searchQuery = ""
    @Published var isEditing = false
    @Published var isLoading = true
    var timetables: [MockTimeTable] = [MockTimeTable].init(repeating: MockTimeTable(), count: Int.random(in: 1 ... 5))
}

// 1 .〇〇Viewを<T: TimeTableViewModelProtocol>に準拠させる。
struct MockAPIView<T: TimeTableViewModelProtocol>: View {

    @StateObject var vm: T  // 2. T(TimeTableViewModelProtocol)をインスタンス化

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

protocol TimeTableViewModelProtocol: ObservableObject {
    associatedtype ListData: TimeTableProtocol
    var timetables: [ListData] { get set }
    var searchQuery: String { get set }
    var isEditing: Bool { get set }
    var isLoading: Bool { get set }
    var channels: [ChannelModelImpl] { get set }
    func getChannelTimeTable()
}

struct MockAPIView_Previews: PreviewProvider {

    static var previews: some View {
        MockAPIView(vm: MockTimeTableViewModel())
    }
}

// Mock用のデータ構造

struct MockTimeTableResult: Decodable {
    let data: [MockTimeTable]
}
