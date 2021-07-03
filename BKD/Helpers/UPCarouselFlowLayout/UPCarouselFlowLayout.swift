//
//  UPCarouselFlowLayout.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit


public enum UPCarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}


open class UPCarouselFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }
    
    @IBInspectable open var sideItemScale: CGFloat = 8
    @IBInspectable open var sideItemAlpha: CGFloat = 0.6
    @IBInspectable open var sideItemShift: CGFloat = 0.0
    open var spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 1)
    
    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    
    
    override open func prepare() {
        super.prepare()
        let currentState = LayoutState(size: self.collectionView!.bounds.size, direction: .horizontal)
        
        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = true
            //(self.scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        let scaledItemOffset =  (side - side*self.sideItemScale) / 2
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    static var currenIndexPath: IndexPath?
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let collectionCenter = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio:CGFloat = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        print(ratio)
        var scale:CGFloat = ratio * (1 - self.sideItemScale) + self.sideItemScale
        var transformRotation: CATransform3D?

        if scale < 0.9 {
            scale = 0.9
            if let indexPath = UPCarouselFlowLayout.currenIndexPath {
                let diff = 4 - UPCarouselFlowLayout.currenIndexPath!.row

                if indexPath.row < attributes.indexPath.row {
                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1 / 500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(45.0 * M_PI / 180.0), 0.0, 1.0, 0.0);
                    var val = 0.0;
                    switch diff {
                    case 1:
                        val = Double(distance / -2.0)
                    case 2:
                        switch attributes.indexPath.row {
                        case 3:
                            val = Double(distance / -2.0)
                        case 4:
                            val = Double(distance / -2) * 3.5
                        default:
                            break
                        }
                    case 3:
                        switch attributes.indexPath.row {
                        case 2:
                            val = Double(distance / -2.0)
                        case 3:
                            val = Double(distance / -2) * 3.3
                        case 4:
                            val = Double(distance / -2) * 4.5
                        default:
                            break
                        }
                    case 4:
                        switch attributes.indexPath.row {
                        case 1:
                            val = Double(distance / -2.0)
                        case 2:
                            val = Double(distance / -2.0) * 3.3
                        case 3:
                            val = Double(distance / -2.0) * 4.5
                        case 4:
                            val = Double(distance / -2) * 5.7
                        default:
                            break
                        }
                    default:
                        break
                    }
                   
                 
                    var transform = CATransform3DTranslate(rotationAndPerspectiveTransform, CGFloat(val), 0, 0)
                    transformRotation = transform
                    print("index = \(attributes.indexPath.row) value \(val) diff = \(diff)")
                } else {
                    let diff = UPCarouselFlowLayout.currenIndexPath!.row
                    var val = 0.0;
                    switch diff {
                    case 1:
                        val = Double(distance / 2.0)
                    case 2:
                        switch attributes.indexPath.row {
                        case 0:
                            val = Double(distance / 2.0) * 3.5
                        case 1:
                            val = Double(distance / 2)
                        default:
                            break
                        }
                    case 3:
                        switch attributes.indexPath.row {
                        case 0:
                            val = Double(distance / 2.0) * 4.5
                        case 1:
                            val = Double(distance / 2) * 3.3
                        case 2:
                            val = Double(distance / 2)
                        default:
                            break
                        }
                    case 4:
                        switch attributes.indexPath.row {
                        case 0:
                            val = Double(distance / 2.0) * 5.7
                        case 1:
                            val = Double(distance / 2.0) * 4.5
                        case 2:
                            val = Double(distance / 2.0) * 3.3
                        case 3:
                            val = Double(distance / 2)
                        default:
                            break
                        }
                    default:
                        break
                    }
                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1 / -500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(45.0 * M_PI / 180.0), 0.0, 1.0, 0.0);
                    var transform = CATransform3DTranslate(rotationAndPerspectiveTransform, CGFloat( val), 0, 0)
                    transformRotation = transform
                    print("11index = \(attributes.indexPath.row) value \(val) diff = \(diff)")

                }
            } else {
                UPCarouselFlowLayout.currenIndexPath = attributes.indexPath
            var rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1 / -500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(45.0 * M_PI / 180.0), 0.0, 1.0, 0.0);
            var transform = CATransform3DTranslate(rotationAndPerspectiveTransform, CGFloat(attributes.indexPath.row * 10), 0, 0)
            // 9

            transformRotation = transform// CATransform3DMakeAffineTransform(CGAffineTransform.init(scaleX: 0.8, y: 0.5))// CATransform3DRotate(CATransform3DIdentity, CGFloat(-35.0 * M_PI / 180.0), 0, 0.9, 0)
            }

        } else {
            UPCarouselFlowLayout.currenIndexPath = attributes.indexPath
            transformRotation = CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0)

        }
       
        let shift = (1 - ratio) * self.sideItemShift
        attributes.alpha = alpha
    
       //attributes.transform3D = CATransform3DRotate(CATransform3DIdentity, 20, 0, 10, 0)
        let transformScale = CATransform3DScale(CATransform3DIdentity, CGFloat(scale), CGFloat(scale), 1)
        let transform = CATransform3DConcat(transformRotation!, transformScale);
        attributes.transform3D = transform
       // attributes.transform3D = transformRotation!
        attributes.zIndex = Int(alpha * 10)
        
        if isHorizontal {
            attributes.center.y = attributes.center.y + CGFloat(shift)
        } else {
            attributes.center.x = attributes.center.x + CGFloat(shift)
        }
        
        return attributes
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
}

