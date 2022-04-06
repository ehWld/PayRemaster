//
//  VerticalFlowLayout.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/07.
//

import UIKit

protocol VerticalFlowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForPillAtIndexPath indexPath: IndexPath) -> CGSize
}

class VerticalFlowLayout: UICollectionViewLayout {
    weak var delegate: VerticalFlowLayoutDelegate?
    
    var layoutHeight: CGFloat = 0
    var headerHeight: CGFloat = 0
    var itemInsets: UIEdgeInsets = .zero
    var itemSpacing: CGFloat = 0
    
    private var headerCache: [UICollectionViewLayoutAttributes] = []
    private var itemCache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()

        itemCache.removeAll()
        headerCache.removeAll()
        layoutHeight = 0
        
        guard let collectionView = collectionView else { return }
        
        var layoutWidthIterator: CGFloat = 0.0
        
        for section in 0..<collectionView.numberOfSections {
            var itemSize: CGSize = .zero
            
            let attrHeader = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
            attrHeader.frame = CGRect(x: 0.0, y: layoutHeight, width: collectionView.frame.size.width, height: headerHeight)
            layoutHeight += headerHeight + itemInsets.top
            headerCache.append(attrHeader)
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                itemSize = delegate?.collectionView(collectionView, sizeForPillAtIndexPath: indexPath) ?? .zero
                
                if (layoutWidthIterator + itemSize.width + itemInsets.left + itemInsets.right) > collectionView.frame.width {
                    layoutWidthIterator = 0.0
                    layoutHeight += itemSize.height + itemSpacing
                }
                
                let frame = CGRect(x: layoutWidthIterator + itemInsets.left, y: layoutHeight, width: itemSize.width, height: itemSize.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                itemCache.append(attributes)
                layoutWidthIterator = layoutWidthIterator + frame.width + itemSpacing
            }
            
            layoutHeight += itemSize.height + itemInsets.bottom
            layoutWidthIterator = 0.0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)-> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in itemCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        for attributes in headerCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        return headerCache[indexPath.section]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        return itemCache[indexPath.row]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: layoutHeight)
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

