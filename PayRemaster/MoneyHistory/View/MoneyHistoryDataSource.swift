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
        // FIXME: Item 별로 날짜 내림차순 정렬 후, Section을 만들어서 append 해야할듯.. PaymentHistoryViewModel의 applyData() 참고
        snapshot.appendSections([3])
        snapshot.appendItems(newItems)
        apply(snapshot, animatingDifferences: animated)
    }
    
}
