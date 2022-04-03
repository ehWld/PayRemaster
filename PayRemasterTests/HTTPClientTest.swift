//
//  HTTPClientTest.swift
//  PayRemasterTests
//
//  Created by heizel.nut on 2022/04/02.
//

import XCTest
import Combine
@testable import PayRemaster

class HTTPClientTest: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    func testExample() throws {
//        let expectation = XCTestExpectation()
//        let headers = ["Authorization": "MTY0ODg5MjIyMzgzMQ=="]
//        let urlString = "http://127.0.0.1:8080/money/histories"
//        let publisher: AnyPublisher<[Transaction], Error> = HTTPClient.shared.request(urlString: urlString, method: .GET, headers: headers)
//        publisher
//            .sink { completion in
//                guard case .failure(let error) = completion else { return }
//                print(error)
//                XCTFail()
//                expectation.fulfill()
//            } receiveValue: { histories in
//                print(histories)
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 10)
    }


}
