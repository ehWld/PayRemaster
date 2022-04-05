//
//  Combine+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/04.
//

import Foundation
import Combine

extension Publishers {
    struct ZipMany<Element, Failure: Error>: Publisher {
        typealias Output = [Element]
        
        private let upstreams: [AnyPublisher<Element, Failure>]
        
        init(_ upstreams: [AnyPublisher<Element, Failure>]) {
            self.upstreams = upstreams
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let initial = Just<[Element]>([])
                .setFailureType(to: Failure.self)
                .eraseToAnyPublisher()
            
            let zipped = upstreams.reduce(into: initial) { result, upstream in
                result = result.zip(upstream) { values, value in
                    values + [value]
                }
                .eraseToAnyPublisher()
            }
            
            zipped.receive(subscriber: subscriber)
        }
    }
}
