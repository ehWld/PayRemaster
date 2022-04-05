//
//  MoneyHistoriesViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/29.
//

import UIKit
import Combine

class MoneyHistoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: FilterView!
    
    @IBOutlet weak var filterTopConstraint: NSLayoutConstraint!
    
    private lazy var dataSource = MoneyHistoryDataSource(tableView: self.tableView)
    
    private var viewModel: MoneyHistoryViewModel = MoneyHistoryViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.action(.viewDidLoad)
    }
    
    private func configureUI() {
        self.title = "내역"
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10
        navigationController?.navigationBar.largeTitleTextAttributes?[.paragraphStyle] = style
        
        tableView.register(MoneyHistoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: MoneyHistoryHeaderView.identifier)
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: filterView.minHeight, left: 0, bottom: 0, right: 0)
    }
    
    private func bind() {
        viewModel.$histories
            .sink { [weak self] histories in
                print(histories.count)
                self?.dataSource.apply(histories)
            }
            .store(in: &cancellables)
        
        viewModel.$filters
            .sink { [weak self] filters in
                self?.filterView.configure(with: filters)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                print(error)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Extension: UITableViewDelegate

extension MoneyHistoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MoneyHistoryHeaderView.identifier) as! MoneyHistoryHeaderView
        let sectionTitle = dataSource.snapshot().sectionIdentifiers[section]
        headerView.configure(with: sectionTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -filterView.frame.height {
            filterTopConstraint.constant = -(scrollView.contentOffset.y + filterView.frame.height)
        } else {
            filterTopConstraint.constant = 0
        }
    }
}

