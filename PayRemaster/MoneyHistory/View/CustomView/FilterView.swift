//
//  FilterView.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/04.
//

import UIKit
import Combine

class FilterView: UIView {

    // MARK: - Subviews
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.setImage(UIImage(named: "arrow_up"), for: .selected)
        button.tintColor = .grey990
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Properties
    let minHeight: CGFloat = 72
    
    private var horizontalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private var filters: [Filter] = [Filter(type: "", title: "전체"), Filter(type: "", title: "송금"), Filter(type: "", title: "페이머니카드"), Filter(type: "", title: "도대체언제자냐고"), Filter(type: "", title: "전체"), Filter(type: "", title: "송금"), Filter(type: "", title: "페이머니카드"), Filter(type: "", title: "도대체언제자냐고")]
    private var selectedIndex: IndexPath = .init(item: 0, section: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configure(with filters: [Filter]) {
        self.filters = filters
        collectionView.reloadData()
    }
    
    private func configureUI() {
        backgroundColor = .background
        
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(expandButton)
        NSLayoutConstraint.activate([
            expandButton.widthAnchor.constraint(equalToConstant: 68),
            expandButton.heightAnchor.constraint(equalToConstant: 72),
            expandButton.topAnchor.constraint(equalTo: self.topAnchor),
            expandButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        expandButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        collectionView.collectionViewLayout = horizontalLayout
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
}

// MARK: - CollectionViewDataSource
extension FilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        cell.configure(with: filters[indexPath.item])
        return cell
    }
    
}

// MARK: - CollectionViewDelegate
extension FilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousCell = collectionView.cellForItem(at: selectedIndex) as! FilterCell
        previousCell.isSelected = false
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! FilterCell
        currentCell.isSelected = true
        selectedIndex = indexPath
    }
}

extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = FilterCell()
        cell.configure(with: filters[indexPath.item])
        return CGSize(width: cell.intrinsicWidth, height: 32)
    }
}

