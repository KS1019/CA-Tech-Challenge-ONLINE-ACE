//
//  MockAPIView.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/08/12.
//
import Combine
import SwiftUI

// ViewModel
class MockAPIViewModel: ObservableObject {
    var timetables = [MockTimeTable].init(repeating: MockTimeTable(), count: 10)
}
// View
struct MockAPIView: View {
    @StateObject var vm = MockAPIViewModel()

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

struct MockAPIView_Previews: PreviewProvider {
    static var previews: some View {
        MockAPIView()
    }
}

// Mock用のデータ構造
struct MockTimeTable: TimeTableProtocol {
    var id: String

    var title: String

    var highlight: String

    var detailHighlight: String

    var startAt: Int

    var endAt: Int

    var channelId: String

    var labels: [String: Bool]

    init() {
        self.id = "EQYyywjosSkxUX"
        self.title = "ENLIGHT #1"
        self.highlight = "Test Highlight"
        self.detailHighlight = "Test detailHighlight"
        self.startAt = 1_627_232_880
        self.endAt = 1_627_237_860
        self.channelId = "fishing"
        self.labels = [
            "live": false,
            "first": false,
            "last": false,
            "bundle": false,
            "new": false,
            "pickup": false
        ]
    }

}

struct MockTimeTableResult: Decodable {
    let data: [MockTimeTable]
}
