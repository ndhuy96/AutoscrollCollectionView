//
//  ViewController.swift
//  AutoscrollCollectionView
//
//  Created by Nguyen Duc Huy B on 6/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import UIKit

let kCollectionViewNumberOfSets: Int = 4
let kCollectionViewLineSpacing: CGFloat = 4.0
let kNumberOfBanners: Int = 6
let kMaxAutoScrollSpeed: CGFloat = 100
let kMinAutoScrollSpeed: CGFloat = 0
let kCentimeterOf1Inch: CGFloat = 2.54
let kAutoScrollDefaultTimerInterval: CGFloat = 0.01

final class ViewController: UIViewController {
    @IBOutlet private weak var dishesCollectionView: InfinityCollectionView!
    
    private var bannerItems: [String] = []
    private var autoScrollSpeed: CGFloat! // mm/s
    private var timerInterval: CGFloat!
    private var movePointAmountForTimerInterval: CGFloat!
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        // Initial Data
        for n in 1...kNumberOfBanners {
            bannerItems.append("login_scroller_\(n)_Normal")
        }
        
        // CollectionView's Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kCollectionViewLineSpacing
        layout.scrollDirection = .horizontal
        let widthContent = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: widthContent, height: widthContent)
        dishesCollectionView.collectionViewLayout = layout
        
        // CollectionView's Settings
        dishesCollectionView.dataSource = self
        dishesCollectionView.showsVerticalScrollIndicator = false
        dishesCollectionView.showsHorizontalScrollIndicator = false
        dishesCollectionView.scrollsToTop = false
        dishesCollectionView.numberOfSets = kCollectionViewNumberOfSets
        
        setAutoScrollSpeed(30)
    }
    
    private func setAutoScrollSpeed(_ autoScrollSpeed: CGFloat) {
        var availableAutoScrollSpeed: CGFloat
        if autoScrollSpeed > kMaxAutoScrollSpeed {
            availableAutoScrollSpeed = kMaxAutoScrollSpeed
        } else if autoScrollSpeed < kMinAutoScrollSpeed {
            availableAutoScrollSpeed = kMinAutoScrollSpeed
        } else {
            availableAutoScrollSpeed = autoScrollSpeed
        }

        self.autoScrollSpeed = availableAutoScrollSpeed
        if (self.autoScrollSpeed > 0) {
            let movePixelAmountForOneSeconds = self.autoScrollSpeed * CGFloat(DeviceInfo.getPixelPerInch()) * 0.1 / kCentimeterOf1Inch
            let movePointForOneSeconds = movePixelAmountForOneSeconds / UIScreen.main.scale
            let movePointAmountForTimerInterval = movePointForOneSeconds * kAutoScrollDefaultTimerInterval
            let floorMovePointAmountForTimerInterval = floor(movePointAmountForTimerInterval)
            if floorMovePointAmountForTimerInterval < 1 {
                self.movePointAmountForTimerInterval = 1
            } else {
                self.movePointAmountForTimerInterval = floorMovePointAmountForTimerInterval
            }
            self.timerInterval = self.movePointAmountForTimerInterval / movePointForOneSeconds
        }
        
        startAutoScroll()
    }
    
    private func startAutoScroll() {
        if self.timer.isValid {
            return
        }
        
        if self.autoScrollSpeed == 0 {
            self.stopAutoScroll()
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerInterval),
                                              target: self,
                                              selector: #selector(timerDidFire),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    private func stopAutoScroll() {
        if self.timer.isValid {
            self.timer.invalidate()
        }
    }
    
    @objc
    private func timerDidFire() {
        let nextContentOffset = CGPoint(x: self.dishesCollectionView.contentOffset.x + self.movePointAmountForTimerInterval,
                                        y: self.dishesCollectionView.contentOffset.y)
        self.dishesCollectionView.contentOffset = nextContentOffset
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerItems.count * self.dishesCollectionView.numberOfSets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishesCell", for: indexPath) as! DishesCell
        let correctIndexRow = indexPath.row % self.bannerItems.count
        if (self.bannerItems.count >= correctIndexRow + 1) {
            let item = self.bannerItems[correctIndexRow]
            cell.configCell(item)
        }
        return cell
    }
}

