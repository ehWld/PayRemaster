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
    
    func test_getTokenFromKeyChain_success() throws {
        let expectation = XCTestExpectation()
        let date = Date()
        let testToken = AccessToken("TestToken", expiredDate: date)
        try KeyChain.standard.set(testToken, forKey: "MoneyHistoryToken")
        
        API.accessToken()
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            } receiveValue: { token in
                XCTAssertEqual(token, testToken)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 10)
    }

    func test_getTokenFromServer_success() throws {
        let expectation = XCTestExpectation()
        try KeyChain.standard.delete(forKey: "MoneyHistoryToken")
        
        API.accessToken()
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            } receiveValue: { token in
                XCTAssertTrue(true, token.value)
                print(token)
                print(Date())
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 100)
    }

    
    func test_histories_success() {
        let expectation = XCTestExpectation()
        
        API.histories()
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail(error.localizedDescription)
                print(error)
                expectation.fulfill()
            } receiveValue: { histories in
                print(histories)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_historyDetail_success() {
        let expectation = XCTestExpectation()
        
        API.historyDetail(of: "6270C6DB-FE1E-4BC5-B89B-C1EDDA316A89")
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail(error.localizedDescription)
                print(error)
                expectation.fulfill()
            } receiveValue: { histories in
                print(histories.amount, histories.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
