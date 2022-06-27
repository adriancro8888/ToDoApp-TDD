//
//  APIClientTests.swift
//  ToDoApp_TDDTests
//
//  Created by Felix Titov on 6/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import XCTest
@testable import ToDoApp_TDD

class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var sut: APIClient!
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }
    
    override func tearDownWithError() throws {
        mockURLSession = nil
        sut = nil
    }
    
    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectpath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExpectedQueryParametres() {
        userLogin()
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    func testSuccessfullLoginCreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token expectation")
        
        var codeToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            codeToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(codeToken, "tokenString")
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var codeError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            codeError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(codeError)
        }
    }
    
    func testLoginWhenDataIsNilReturnsError() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var codeError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            codeError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(codeError)
        }
    }
    
    func testLoginWhenResponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
