//
//  KeyChainTest.swift
//  PayRemasterTests
//
//  Created by heizel.nut on 2022/04/03.
//

import XCTest
@testable import PayRemaster

class KeyChainTest: XCTestCase {

    func testExample() throws {
        let testDate = Date()
        let token = AccessToken("TestToken", expiredDate: testDate)
        try KeyChain.standard.set(token, forKey: "testToken")
        let retrieveToken: AccessToken? = try KeyChain.standard.object(forKey: "testToken")
        guard let retrieveToken = retrieveToken else {
            XCTFail()
            return
        }
        XCTAssertEqual(retrieveToken.value, "TestToken")
        XCTAssertEqual(retrieveToken.expiredDate, testDate)
    }


}
