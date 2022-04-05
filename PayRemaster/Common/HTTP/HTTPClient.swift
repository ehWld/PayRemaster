//
//  HTTPClient.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/02.
//

import Foundation
import Combine

class HTTPClient {
    
    enum Methods: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum Errors: LocalizedError {
        case badRequest
    }
    
    static let shared = HTTPClient()
    
    var decoder: JSONDecoder
    
    private init() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
        self.decoder = jsonDecoder
    }
    
    func request<ResponseData: Decodable>(urlString: String,
                                          method: HTTPClient.Methods = .GET,
                                          headers: [String: String]? = nil,
                                          parameters: [String: Any]? = nil
    ) -> AnyPublisher<ResponseData, Error> {
        guard let urlReqest = makeURLRequest(urlString: urlString, method: method, headers: headers, parameters: parameters) else {
            return Fail(error: Errors.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlReqest)
            .tryMap { (data, response) -> Data in
                //FIXME: - Error Handling
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard httpResponse.statusCode == 200 else {
                    print(httpResponse.statusCode)
                    print(String(data: data, encoding: .utf8))
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ResponseData.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func makeURLRequest(urlString: String,
                                method: HTTPClient.Methods = .GET,
                                headers: [String: String]? = nil,
                                parameters: [String: Any]? = nil
    ) -> URLRequest? {
        guard var url = URL(string: urlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var urlRequest: URLRequest

        if let parameters = parameters {
            components.queryItems = parameters.map { (name, value) -> URLQueryItem in
                return URLQueryItem(name: name, value: "\(value)")
            }
            url = components.url ?? url
        }
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { (key, value) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }

        return urlRequest
    }
    
}
