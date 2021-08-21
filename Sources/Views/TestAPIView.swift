//
//  TestAPI.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/20.
//

import Combine
import SwiftUI

struct TestAPIView: View {
    @ObservedObject var vm: TestAPIViewModel
    let testList = [Channel(id: "d", title: "f"), Channel(id: "ff", title: "fdf")]

    var body: some View {
        VStack {
            Button("POST") {
                // TODO: 端末に紐づいたUUIDに変更
                vm.postReservationData(userId: UUID().uuidString.lowercased(), programId: "Dxgq71w1i9kofM")
            }

            List(vm.channelList, id: \.self) { channel in
                Text(channel.title)
            }

        }
        .onAppear {
            vm.getChannelList()
            vm.getTimeTableData(firstAt: 1_426_323_200, lastAt: 1_626_285_600)
        }
    }
}

struct TestAPI_Previews: PreviewProvider {
    static var previews: some View {
        TestAPIView(vm: TestAPIViewModel())
    }
}

class TestAPIViewModel: ObservableObject {
    var channelList: [Channel] = []
    var timetables: [TimeTable] = []
    let repository = TimeTableRepositoryImpl()

    private var subscriptions = Set<AnyCancellable>()
    func getTimeTableData(firstAt: Int, lastAt: Int) {
        repository.fetchTimeTableData(firstAt: firstAt, lastAt: lastAt, channelId: nil, labels: nil)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")

                case let .failure(error):
                    print(error)

                }

            } receiveValue: { data in
                self.timetables += data
                print(self.timetables)
            }
            .store(in: &self.subscriptions)
    }
    func postReservationData(userId: String, programId: String) {

        repository.postReservationData(userId: userId, programId: programId) { result in

            switch result {
            case .success():
                print("成功")
            case let .failure(error):
                print(error)
            }
        }

    }
    func getChannelList() {
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")

                case let .failure(error):
                    print(error)

                }

            } receiveValue: { data in
                self.channelList += data
                print(self.channelList)
            }
            .store(in: &self.subscriptions)
    }

}
