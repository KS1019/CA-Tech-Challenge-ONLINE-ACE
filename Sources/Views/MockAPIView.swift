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
    var timetables: [MockTimeTable] = [MockTimeTable].init(repeating: MockTimeTable(), count: 10)
}

// View
struct MockAPIView<T: TimeTableViewModelProtocol>: View {
    // 1 .〇〇Viewを<T: TimeTableViewModelProtocol>に準拠させる。
    // TimeTableViewModelProtocolをインスタンス化
    @StateObject var vm: T

    var body: some View {
        List(vm.timetables) { timetable in
            VStack(alignment: .leading) {
                Text(timetable.title)
                    .font(Font.system(size: 24).bold())
                Text(timetable.id)
                Text(timetable.channelId)
                    .foregroundColor(Color.red)

            }
        }
    }
}

protocol TimeTableViewModelProtocol: ObservableObject {
    associatedtype ListData: TimeTableProtocol
    var timetables: [ListData] { get set }
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
