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
        self.title = "내역"
        tableView.dataSource = self
    }

}

extension MoneyHistoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

