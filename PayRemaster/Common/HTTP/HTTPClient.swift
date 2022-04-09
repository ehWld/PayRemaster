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
        case badServerResponse
        case unhandled
    }
    
    static let shared = HTTPClient()
    
    var decoder: JSONDecoder
    
    private init() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
        self.decoder = jsonDecoder
    }
    
    func request(urlString: String,
                 method: HTTPClient.Methods = .GET,
                 headers: [String: String]? = nil,
                 parameters: [String: Any]? = nil
    ) -> AnyPublisher<Data, Error> {
        guard let urlReqest = makeURLRequest(urlString: urlString, method: method, headers: headers, parameters: parameters) else {
            return Fail(error: Errors.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlReqest)
            .mapError { error -> Error in
                if -1009 ... -1000 ~= error.errorCode {
                    return PayError.networkError
                }
                return error
            }
            .tryMap { [weak self] (data, response) -> Data in
                try self?.handleError(maybeData: data, maybeHttpResponse: response)
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func request<ResponseData: Decodable>(urlString: String,
                                          method: HTTPClient.Methods = .GET,
                                          headers: [String: String]? = nil,
                                          parameters: [String: Any]? = nil
    ) -> AnyPublisher<ResponseData, Error> {
        return request(urlString: urlString, method: method, headers: headers, parameters: parameters)
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
    
    private func handleError(maybeData: Data, maybeHttpResponse: URLResponse) throws {
        guard let httpResponse = maybeHttpResponse as? HTTPURLResponse else {
            throw Errors.badServerResponse
        }
        
        let statusCode = httpResponse.statusCode
        if 200..<300 ~= statusCode { return }
        
        guard let payErrorDTO = try? JSONDecoder().decode(PayErrorDTO.self, from: maybeData) else {
            throw Errors.unhandled
        }
        
        switch payErrorDTO.reason {
        case "NEED_TOKEN": throw PayError.needToken
        case "EXPIRED_TOKEN": throw PayError.expiredToken
        case "DATA_NOT_FOUND": throw PayError.dataNotFound
        case "INTERNAL_SERVER_ERROR": throw PayError.internalServerError
        case "FORCE_UPDATE": throw PayError.forceUpdate
        case "INSPECTION_TIME": throw PayError.inspectionTime
        default: throw PayError.unhandled
        }
    }
    
}
