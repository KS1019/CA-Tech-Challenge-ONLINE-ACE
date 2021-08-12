//
//  TimetableDataManager.swift
//  ace-c-iosTests
//
//  Created by TanakaHirokazu on 2021/08/12.
//

@testable import ace_c_ios
import OHHTTPStubs
import XCTest


class TimetableDataManager: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    private var timeTableManager: TimeTableManager!
    override func setUp() {
        super.setUp()
        timeTableManager = TimeTableManager.shared
        stub(condition: isHost("C.ACE.ace-c-ios")) { _ in
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("TimetableResponse.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
        }
    }
    
    override func tearDown() {
        timeTableManager = nil
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testリクエストが正しく飛んでデータ変換できているか() {
        let exp = expectation(description: #function)
        //スタブを準備
        
        timeTableManager.fetchRecruitDatas {[weak self] in
            XCTAssertEqual(self?.timeTableManager.datas![0].id, "EQYyywjosSkxUX")
//            XCTAssertEqual(self?.timeTableManager.datas![0].id, "わざと失敗させるコード")
            XCTAssertEqual(self?.timeTableManager.datas![0].startAt, 1627232880)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        
    }
    
    
}


class APIManager {
    
    func fetchUser(completion: @escaping ((Result<[TimeTable], Error>) -> Void)) {
        let url = URL(string: "https://C.ACE.ace-c-ios/projects")!
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
                
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                
                let recruitData = try decoder.decode(TimeTableResult.self, from: data).data
                debugPrint(recruitData)
                completion(.success(recruitData))
                
            } catch {
                print(error.localizedDescription)
                
                //                completion(.failure(error))
                
            }
            
        }
        
        session.resume()
    }
}


class TimeTableManager {
    static let shared = TimeTableManager()
    private init() {}
    private(set) var datas: [TimeTable]?
    
    func fetchRecruitDatas(completion: @escaping () -> Void) {
        let apiManager = APIManager()
        apiManager.fetchUser { [weak self] result in
            switch result {
            case .success(let datas):
                self?.datas = datas
                print("success")
                completion()
            case .failure(_):
                print("失敗")
                break
                
            }
        }
    }
    
}


import Combine
import Foundation

struct TimeTableResult: Decodable {
    let data: [TimeTable]
}

struct TimeTable: Decodable, Identifiable {
    let id: String
    let title: String
    let startAt: Int
    let endAt: Int
    let channelId: String
}
