//
//  MoneyHistoriesViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/29.
//

import UIKit

class MoneyHistoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        self.title = "내역"
        tableView.dataSource = self
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10
        navigationController?.navigationBar.largeTitleTextAttributes?[.paragraphStyle] = style
    }
    
    private func configureTableView() {
        tableView.dataSource = self
    }

}

// MARK: - Extension: UITableView

extension MoneyHistoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoneyHistoryCell.identifier, for: indexPath) as? MoneyHistoryCell else { return UITableViewCell() }
        return cell
    }
    
}

