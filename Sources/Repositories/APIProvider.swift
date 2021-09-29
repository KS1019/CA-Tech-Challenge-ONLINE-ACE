//
//  APIProvider.swift
//  ace-c-ios
//
//  Created by TanakaHirokazu on 2021/09/14.
//

import Combine
import Foundation

protocol APIProvider {
    // DataTaskPublisherのモックが作りにくいため、独自のPublisherを作成
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // override resume and call the closure

    override func resume() {
        closure()
    }
}

extension URLSession: APIProvider {
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

struct MockAPIProvider: APIProvider {
    var data: Data?
    var error: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }

    }

    // swiftlint:disable force_unwrapping
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let data = "Hello, world!".data(using: .utf8)!
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
