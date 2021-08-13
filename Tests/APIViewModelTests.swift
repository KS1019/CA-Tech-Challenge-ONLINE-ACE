//
//  APIViewModelTests.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
@testable import ace_c_ios
import Combine
import XCTest

// ViewModelのテスト
class APIReposTests: XCTestCase {
    var vm = APIViewModel(repository: TimeTableRepositoryImpl())

    func test_チャンネルを指定したAPIを叩いて正常にクエリを変更出来ているか() {
        vm.channelId = "fishing"
        XCTAssertEqual(vm.channelId, "fishing")
    }
}

// ViewModel

class APIViewModel: ObservableObject {

    @Published private(set) var state = State()
    @Published var channelId = ""
    @Published var isError = false
    private var subscriptions = Set<AnyCancellable>()

    private let repository: TimeTableRepositoryImpl

    // TODO: 汎化させる
    init(repository: TimeTableRepositoryImpl) {
        self.repository = repository

    }

    func getChannelResponse() {
        repository.fetchTimeTableData(channelId: channelId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.state.isLoading = true
                    self.isError = false

                case let .failure(error):
                    self.isError = true
                    print(error.localizedDescription)
                }
            } receiveValue: { timetables in
                self.state.response += timetables
            }
            .store(in: &self.subscriptions)

    }

    struct State {
        var response: [TimeTable] = []
        var isLoading = true
    }

}