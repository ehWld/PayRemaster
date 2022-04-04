//
//  MoneyHistoriesViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/29.
//

import UIKit

class MoneyHistoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: FilterView!
    
    @IBOutlet weak var filterTopConstraint: NSLayoutConstraint!
    
    private lazy var dataSource = MoneyHistoryDataSource(tableView: self.tableView)
    
    var mockItems: [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        for _ in 0..<20 {
            let new = History(id: "", date: Date(), amount: 100000)
            mockItems.append(new)
        }
        dataSource.apply(mockItems)
        
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
    
}

// MARK: - Extension: UITableViewDelegate

extension MoneyHistoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MoneyHistoryHeaderView.identifier) as! MoneyHistoryHeaderView
        let section = dataSource.snapshot().sectionIdentifiers[section]
        headerView.dateLabel.text = String(section)
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

