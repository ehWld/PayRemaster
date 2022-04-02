//
//  MoneyHistoriesViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/29.
//

import UIKit

class MoneyHistoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource = MoneyHistoryDataSource(tableView: self.tableView)
    
    var mockItems: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        for _ in 0..<20 {
            let new = Transaction(id: "", date: Date(), amount: 100000)
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
}

