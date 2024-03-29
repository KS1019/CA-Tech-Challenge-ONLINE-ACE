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
    let userId = UUID().uuidString.lowercased()
    var body: some View {
        VStack {
            Button("POST") {
                print(userId)
                vm.postReservationData(userId: userId, programId: "Ep6mk79qcVwQCw")

            }
            Button("RESERVED") {
                vm.getReservationData(userId: userId)
            }

            Button("DELETE") {
                print(userId)
                vm.deleteReservationData(userId: userId, programId: "Ep6mk79qcVwQCw")
            }

            Button("GET TimeTable") {
                vm.getTimeTableData(firstAt: 1_426_323_200, lastAt: 1_626_285_600)
            }

            Button("GET Channel") {
                vm.getChannelList()
            }

            List(vm.channelList) { channel in
                Text(channel.title)
            }

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
    let repository = TimeTableRepository(apiProvider: MockAPIProvider())

    private var subscriptions = Set<AnyCancellable>()

    func getReservationData(userId: String) {
        repository.fetchReservationData(userId: userId)
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

    func deleteReservationData(userId: String, programId: String) {

        repository.deleteReservationData(userId: userId, programId: programId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("終了コード")

                case let .failure(error):
                    print(error)

                }

            } receiveValue: {
            }
            .store(in: &self.subscriptions)

    }
    func postReservationData(userId: String, programId: String) {

        repository.postReservationData(reservationData: ReservationData(userId: userId, programId: programId))
            .sink { completion in
                switch completion {
                case .finished:
                    print("成功")

                case let .failure(error):
                    print(error)
                }

            } receiveValue: { error in
                print(error as Any)
            }
            .store(in: &self.subscriptions)

    }

    func getChannelList() {
        repository.fetchChannelData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("成功")

                case let .failure(error):
                    print(error)

                }

            } receiveValue: { data in
                self.channelList += data
                self.channelList.forEach { channel in
                    print(channel.title)
                }
            }
            .store(in: &self.subscriptions)
    }

}
