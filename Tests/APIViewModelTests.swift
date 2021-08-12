//
//  APIViewModelTests.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//
@testable import ace_c_ios
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

// ViewModelのテスト
class APIViewModelTests: XCTestCase {
    var vm = APIViewModel(repository: TimeTableRepositoryImpl())
    var reposotory = TimeTableRepositoryImpl()
    var isError = false
    private var subscriptions = Set<AnyCancellable>()
    var response: [TimeTable] = []
    override func setUp() {
        super.setUp()
        stub(condition: isHost("C.ACE.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("TimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }
        stub(condition: isHost("failure.ace-c-ios")) { _ in
            return fixture(
                // swiftlint:disable force_unwrapping
                filePath: OHPathForFile("FailureTimetableResponse.json", type(of: self))!,
                headers: ["Content-Type": "application/json"]
            )
        }
        
    }

    func test_チャンネルを指定したAPIを叩いて正常にクエリを変更出来ているか() {
        vm.channelId = "fishing"
        XCTAssertEqual(vm.channelId, "fishing")
    }
    func test_データ取得成功時にrecieveValueが呼ばれているか() {

        let exp = expectation(description: #function)
        reposotory.fetchTimeTableData(channelId: "fishing")
            .sink { completion in
                switch completion {
                case .finished: break
                   
                case let .failure(error):
                   XCTAssertNotNil(error)
                    
                }
            } receiveValue: { timetables in
                self.response += timetables
                exp.fulfill()
            }
            .store(in: &self.subscriptions)
        
        wait(for: [exp], timeout: 3.0)
        
    }
    
    func test_データ取得失敗時にfailureが呼ばれているか() {
        let exp = expectation(description: #function)
        reposotory.fetchFailureTimeTableData(channelId: "fishing")
            .sink { completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    XCTAssertNotNil(error)
                    exp.fulfill()
                    self.isError = true
                    
                    
                }
            } receiveValue: { timetables in
                self.response += timetables
               
//                exp.fulfill() // わざと失敗
            }
            .store(in: &self.subscriptions)
        
        wait(for: [exp], timeout: 3.0)
    }
    
    

}



// ViewModel

class APIViewModel: ObservableObject {

    @Published private(set) var state = State()
    @Published var channelId = ""
    @Published var isError = false
    private var subscriptions = Set<AnyCancellable>()
    
    private let repository: TimeTableRepositoryImpl

    //TODO: 汎化させる
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
