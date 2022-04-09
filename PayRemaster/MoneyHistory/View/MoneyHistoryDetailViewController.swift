//
//  MoneyHistoryDetailViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/05.
//

import UIKit
import Combine

class MoneyHistoryDetailViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel: MoneyHistoryDetailViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private init?(coder: NSCoder, history: History, filters: [HistoryType]) {
        super.init(coder: coder)
        viewModel = MoneyHistoryDetailViewModel(history, filters)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Setup
    
    private func configureUI() {
        title = "상세내역"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bind() {
        viewModel.$historyDetail
            .compactMap { $0 }
            .sink { [weak self] historyDetail in
                self?.configureUI(with: historyDetail)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .sink { [weak self] error in
                guard let error = error as? PayError else { return }
                self?.showPayErrorAlert(error) {
                    self?.viewModel.action(.resolveErrorDidTap)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureUI(with historyDetail: HistoryDetail) {
        typeLabel.text = historyDetail.type.title
        titleLabel.text = "\(historyDetail.title)(\(historyDetail.subtitle))"
        amountTitleLabel.text = historyDetail.amountTitle
        amountLabel.text = historyDetail.amount.wonFormatted
        dateLabel.text = historyDetail.date.formattedString("yyyy. M. d(E) hh:mm")
        balanceLabel.text = historyDetail.balance.wonFormatted
    }
    
    // MARK: - Action

    @IBAction func confirmButtonPushed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Instantiate

extension MoneyHistoryDetailViewController {
    static func instantiate(_ history: History, _ filters: [HistoryType]) -> MoneyHistoryDetailViewController {
        return UIStoryboard(name: "MoneyHistoryDetail", bundle: nil).instantiateViewController(identifier: "MoneyHistoryDetail") { coder in
            MoneyHistoryDetailViewController(coder: coder, history: history, filters: filters)
        }
    }
}
