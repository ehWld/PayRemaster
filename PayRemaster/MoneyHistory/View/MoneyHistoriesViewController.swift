//
//  MoneyHistoriesViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/29.
//

import UIKit
import Combine

class MoneyHistoriesViewController: UIViewController {

    // MARK: - Subviews
    
    @IBOutlet weak var filterTableView: TypeFilterTableView!
    @IBOutlet weak var dateFilterView: DateFilterView!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Properties

    private lazy var dataSource = MoneyHistoryDataSource(tableView: self.filterTableView)
    
    private var viewModel: MoneyHistoryViewModel = MoneyHistoryViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Setup
    
    private func configureUI() {
        self.title = "내역"
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.tintColor = .grey990
        navigationController?.navigationBar.layoutMargins.left = 24
        navigationItem.largeTitleDisplayMode = .always

        filterTableView.register(MoneyHistoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: MoneyHistoryHeaderView.identifier)
        filterTableView.delegate = self
        emptyView.isHidden = true
    }
    
    private func bind() {
        filterTableView.filterView.$selectedType
            .dropFirst()
            .sink { [weak self] type in
                self?.viewModel.action(.filterDidSelected(filter: type))
            }
            .store(in: &cancellables)
        
        dateFilterView.$currentDate
            .dropFirst()
            .sink { [weak self] date in
                self?.viewModel.action(.dateDidSelected(date: date))
            }
            .store(in: &cancellables)
        
        viewModel.$histories
            .sink { [weak self] histories in
                print(histories)
                if histories.isEmpty {
                    self?.emptyView.isHidden = false
                }
                else { self?.emptyView.isHidden = true }
                self?.dataSource.apply(histories)
            }
            .store(in: &cancellables)
        
        viewModel.$filters
            .sink { [weak self] filters in
                self?.filterTableView.configureFilter(with: filters)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let error = error as? PayError else { return }
                self?.showPayErrorAlert(error) {
                    self?.viewModel.action(.resolveErrorDidTap)
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Extension: UITableViewDelegate

extension MoneyHistoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let history = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = MoneyHistoryDetailViewController.instantiate(history, viewModel.filters)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MoneyHistoryHeaderView.identifier) as! MoneyHistoryHeaderView
        let sectionTitle = dataSource.snapshot().sectionIdentifiers[section]
        headerView.configure(with: sectionTitle)
        headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        guard offsetY > contentHeight - height else { return }
        viewModel.action(.didScrollToBottom)
    }
}

