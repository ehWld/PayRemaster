//
//  TypeFilterView.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/04.
//

import UIKit
import Combine

class TypeFilterView: UIView {
    
    // MARK: - Subviews
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TypeFilterCell.self, forCellWithReuseIdentifier: TypeFilterCell.identifier)
        return collectionView
    }()
    
    lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.setImage(UIImage(named: "arrow_up"), for: .selected)
        button.tintColor = .grey990
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(expandButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    let minHeight: CGFloat = 72
    
    @Published var selectedType: HistoryType = HistoryType.all

    private var horizontalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var verticalLayout: VerticalFlowLayout = {
        let layout = VerticalFlowLayout()
        layout.delegate = self
        layout.itemSpacing = 8
        return layout
    }()
    
    private lazy var collectionViewHeightConstraint: NSLayoutConstraint = collectionView.heightAnchor.constraint(equalToConstant: 32)
    
    private var filters: [HistoryType] = []
    private var selectedIndex: IndexPath = .init(item: 0, section: 0)
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Setup
    
    func configure(with filters: [HistoryType], selected: Int = 0) {
        backgroundColor = .background
        self.filters = filters
        collectionView.reloadData()
        self.collectionView.selectItem(at: IndexPath(item: selected, section: 0), animated: true, scrollPosition: [])
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
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor)
        ])
        collectionView.collectionViewLayout = horizontalLayout
        
        collectionViewHeightConstraint.isActive = true
    }
    
    // MARK: - Action
    
    @objc private func expandButtonDidTap(_ sender: UIButton) {
        if sender.isSelected { // 닫기
            sender.isSelected = false
            collectionView.collectionViewLayout = horizontalLayout
            collectionViewHeightConstraint.constant = 32
            self.layoutIfNeeded()
        } else { // 펼치기
            sender.isSelected = true
            collectionView.collectionViewLayout = verticalLayout
            let height = verticalLayout.collectionViewContentSize.height
            collectionViewHeightConstraint.constant = height
            self.layoutIfNeeded()
        }
    }
    
}

// MARK: - CollectionViewDataSource

extension TypeFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeFilterCell.identifier, for: indexPath) as! TypeFilterCell
        cell.configure(with: filters[indexPath.item])
        return cell
    }
    
}

// MARK: - CollectionViewDelegate

extension TypeFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousCell = collectionView.cellForItem(at: selectedIndex) as! TypeFilterCell
        previousCell.isSelected = false
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! TypeFilterCell
        currentCell.isSelected = true
        selectedIndex = indexPath
        selectedType = filters[indexPath.item]
    }
}

// MARK: - CollectionViewLayoutDelegate

extension TypeFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = TypeFilterCell()
        cell.configure(with: filters[indexPath.item])
        return CGSize(width: cell.intrinsicWidth, height: 32)
    }
}

extension TypeFilterView: VerticalFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForPillAtIndexPath indexPath: IndexPath) -> CGSize {
        let cell = TypeFilterCell()
        cell.configure(with: filters[indexPath.item])
        return CGSize(width: cell.intrinsicWidth, height: 32)
    }
}
