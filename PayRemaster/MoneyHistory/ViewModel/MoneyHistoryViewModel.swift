//
//  MoneyHistoryViewModel.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import Foundation
import Combine

class MoneyHistoryViewModel {
    typealias Item = History
    typealias Section = String
    
    // Input
    enum Action {
        case viewDidLoad
        case didScrollToBottom
        case filterDidSelected(filter: Filter)
    }
    
    // Output
    @Published var histories: [History] = []
    @Published var filters: [Filter] = []
    @Published var onRequest: Bool = false
    @Published var error: Error?
    
    // Properties
    private var selectedFilter: Filter?
    private var selectedMonth: Int = Date().month
    private var currentPage: Int = 0
    private var isEndHistory: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            requestInitialData()
        case .didScrollToBottom:
            requestMoreData()
        case .filterDidSelected(let filter):
            print("")
        }
    }
    
    private func requestInitialData() {
        guard !onRequest else { return }
        onRequest = true
        
        API.histories(filter: nil, month: selectedMonth, page: 0)
            .receive(on: DispatchQueue.main)
            .zip(API.categories())
            .sink { [weak self] completion in
                self?.onRequest = false
                guard case .failure(let error) = completion else { return }
                self?.error = error
            } receiveValue: { [weak self] histories, filters in
                self?.filters = filters
                self?.histories = histories
                if histories.isEmpty { self?.isEndHistory = true }
            }
            .store(in: &cancellables)
    }
    
    private func requestMoreData() {
        guard !onRequest && !isEndHistory else { return }
        onRequest = true
        
        API.histories(filter: selectedFilter?.type, month: selectedMonth, page: currentPage + 1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.onRequest = false
                guard case .failure(let error) = completion else { return }
                self?.error = error
            } receiveValue: { [weak self] histories in
                self?.histories += histories
                if histories.isEmpty { self?.isEndHistory = true }
            }
            .store(in: &cancellables)
    }
    
}

