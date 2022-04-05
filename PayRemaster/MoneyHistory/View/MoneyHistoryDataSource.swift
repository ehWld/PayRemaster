//
//  MoneyHistoryDataSource.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import UIKit

class MoneyHistoryDataSource: UITableViewDiffableDataSource<MoneyHistoryDataSource.Section, MoneyHistoryDataSource.Item> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Section = MoneyHistoryViewModel.Section
    typealias Item = MoneyHistoryViewModel.Item
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: MoneyHistoryCell.identifier, for: indexPath) as! MoneyHistoryCell
            cell.configure(with: item)
            return cell
        }
    }
    
    func apply(_ newItems: [Item], animated: Bool = false) {
        var snapshot = Snapshot()
        let itemDictionary = Dictionary(grouping: newItems) { $0.date.day }
        for key in itemDictionary.keys.sorted(by: >) {
            guard let items = itemDictionary[key],
                  let section = items.first?.date.formattedString("dd일 (E)") else {
                      continue
                  }
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        apply(snapshot, animatingDifferences: animated)
    }
    
}
