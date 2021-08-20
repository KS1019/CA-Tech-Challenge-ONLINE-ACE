//
//  TestAPI.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/20.
//

import Combine
import SwiftUI

struct TestAPI: View {
    @ObservedObject var vm: TestAPIViewModel
    var body: some View {
        LazyVStack {
            ForEach(vm.channelList) { channel in
                Text(channel.title)
            }

        }
        .onAppear {
            vm.getChannelList()

        }
    }
}

struct TestAPI_Previews: PreviewProvider {
    static var previews: some View {
        TestAPI(vm: TestAPIViewModel())
    }
}

class TestAPIViewModel: ObservableObject {
    var channelList: [Channel] = []
    let repository = TimeTableRepositoryImpl()

    private var subscriptions = Set<AnyCancellable>()

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
