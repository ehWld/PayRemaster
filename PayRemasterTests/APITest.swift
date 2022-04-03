//
//  APITest.swift
//  PayRemasterTests
//
//  Created by heizel.nut on 2022/04/02.
//

import XCTest
import Combine
@testable import PayRemaster

class APITest: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    func testExample() throws {
        let expectation = XCTestExpectation()
        API.accessToken()
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            } receiveValue: { token in
                XCTAssertTrue(true, token.value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 10)
    }

}
