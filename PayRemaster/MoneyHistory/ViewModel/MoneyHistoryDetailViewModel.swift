//
//  MoneyHistoryDetailViewModel.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/05.
//

import Foundation
import Combine
import UIKit

class MoneyHistoryDetailViewModel {
    
    // Input
    enum Action {
        case viewDidLoad
        case resolveErrorDidTap
    }
    
    // Output
    @Published var historyDetail: HistoryDetail?
    @Published var onRequest: Bool = false
    @Published var error: Error?
    
    private let history: History
    private let historyTypes: [HistoryType]
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ history: History, _ filters: [HistoryType]) {
        self.history = history
        self.historyTypes = filters
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            requestHistoryDetail()
        case .resolveErrorDidTap:
            requestHistoryDetail()
        }
    }
    
    private func requestHistoryDetail() {
        guard !onRequest else { return }
        onRequest = true
        
        API.historyDetail(of: history.id)
            .receive(on: DispatchQueue.main)
            .tryMap { [weak self] detailDTO -> HistoryDetail in
                let types = self?.historyTypes.filter {
                    $0.type == detailDTO.type
                }
                guard let type = types?.first else { throw PayError.dataNotFound }
                return HistoryDetail(detailDTO, type)
            }
            .sink { [weak self] completion in
                self?.onRequest = false
                guard case .failure(let error) = completion else { return }
                self?.error = error
            } receiveValue: { [weak self] historyDetail in
                self?.historyDetail = historyDetail
            }
            .store(in: &cancellables)
    }
    
}
