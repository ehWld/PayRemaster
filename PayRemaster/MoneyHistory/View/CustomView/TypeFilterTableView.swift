//
//  FilterTableView.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/07.
//

import UIKit
import Combine

class TypeFilterTableView: UITableView {

    // MARK: - Subviews
    
    var filterView: TypeFilterView = TypeFilterView()
    var bottomInset: CGFloat = 70
    
    private var filterTopConstraint: NSLayoutConstraint!
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(frame: .zero, style: .plain)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        bind()
    }
    
    // MARK: - Setup
    
    func configureFilter(with filers: [HistoryType]) {
        filterView.configure(with: filers)
    }
    
    private func configureUI() {
        addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterTopConstraint = filterView.topAnchor.constraint(equalTo: self.topAnchor)
        NSLayoutConstraint.activate([
            filterTopConstraint,
            filterView.widthAnchor.constraint(equalTo: self.widthAnchor),
            filterView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        contentInset = .init(top: filterView.minHeight, left: 0, bottom: bottomInset, right: 0)
    }
    
    private func bind() {
        // scrollview 옵저빙
        self.publisher(for: \.contentOffset, options: .new)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contentOffset in
                self?.setFilterViewTopConstraint(contentOffset)
            }
            .store(in: &cancellables)

        // filterView 펼침/접힘 옵저빙
        filterView.publisher(for: \.bounds, options: .new)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bounds in
                guard let self = self,
                      bounds.height != self.contentInset.top else { return }

                let height = self.contentInset.top
                self.contentInset = .init(top: bounds.height, left: 0, bottom: self.bottomInset, right: 0)
                if self.contentInset.top > -self.contentOffset.y {
                    self.contentOffset.y -= bounds.height - height
                }
            }
            .store(in: &cancellables)
        
        filterView.$selectedType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                guard let self = self else { return }
                self.setContentOffset(.init(x: 0, y: -self.contentInset.top), animated: false)
            }
            .store(in: &cancellables)
    }
    
    private func setFilterViewTopConstraint(_ contentOffSet: CGPoint) {
        if -contentOffset.y > contentInset.top {
            filterTopConstraint.constant =  -contentInset.top
        } else {
            filterTopConstraint.constant = contentOffSet.y
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(filterView)
    }

}
