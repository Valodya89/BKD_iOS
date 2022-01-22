//
//  UICollectionView.swift
//  UICollectionView
//
//  Created by Karine Karapetyan on 29-09-21.
//

import UIKit


extension UICollectionView {
    
    // get center visible cell index path
    func getCurrentVisibleCellIndexPath() -> IndexPath {
        let visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let visibleIndexPath = self.indexPathForItem(at: visiblePoint) else { return IndexPath(item: 0, section: 0) }
        
        return visibleIndexPath
    }
}
