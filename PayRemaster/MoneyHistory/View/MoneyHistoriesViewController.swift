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
            let new = Transaction(id: "", date: Date(), amount: 100000, user: User())
            mockItems.append(new)
        }
        dataSource.apply(mockItems)
    }
    
    private func configureUI() {
        self.title = "내역"
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10
        navigationController?.navigationBar.largeTitleTextAttributes?[.paragraphStyle] = style
    }
    
}

// MARK: - Extension: UITableView


