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
        case filterDidSelected(filter: HistoryType)
        case dateDidSelected(date: Date)
    }
    
    // Output
    @Published var histories: [History] = []
    @Published var filters: [HistoryType] = []
    @Published var historyId: String? = nil
    @Published var onRequest: Bool = false
    @Published var error: Error?
    
    // Properties
    private var selectedFilter: HistoryType?
    private var selectedMonth: Int = Date().month
    private var currentPage: Int = 0
    private var isEndHistory: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            requestInitialData()
        case .didScrollToBottom:
            requestData(for: currentPage + 1)
        case .filterDidSelected(let filter):
            histories = []
            isEndHistory = false
            currentPage = 0
            selectedFilter = filter
            requestData(for: currentPage)
        case .dateDidSelected(let date):
            histories = []
            isEndHistory = false
            currentPage = 0
            selectedMonth = date.month
            requestData(for: currentPage)
        }
    }
    
    private func requestInitialData() {
        guard !onRequest else { return }
        onRequest = true
        
        API.histories(filter: nil, month: selectedMonth, page: 0)
            .zip(API.categories())
            .receive(on: DispatchQueue.main)
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
    
    private func requestData(for page: Int) {
        guard !onRequest && !isEndHistory else { return }
        onRequest = true
        
        API.histories(filter: selectedFilter, month: selectedMonth, page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.onRequest = false
                guard case .failure(let error) = completion else { return }
                self?.error = error
            } receiveValue: { [weak self] histories in
                guard !histories.isEmpty else { self?.isEndHistory = true; return }
                self?.histories += histories
                self?.currentPage += 1
            }
            .store(in: &cancellables)
    }
    
}

