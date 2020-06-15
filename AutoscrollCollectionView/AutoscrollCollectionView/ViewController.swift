//
//  ViewController.swift
//  AutoscrollCollectionView
//
//  Created by Nguyen Duc Huy B on 6/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var dishesCollectionView: InfinityCollectionView!
    private var bannerItems: [String] = []
    private let kCollectionViewNumberOfSets: Int = 4
    private let kCollectionViewLineSpacing: CGFloat = 4.0
    private let kNumberOfBanners: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        
        for n in 1...kNumberOfBanners {
            bannerItems.append("login_scroller_\(n)_Normal")
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kCollectionViewLineSpacing
        layout.scrollDirection = .horizontal
        let widthContent = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: widthContent, height: widthContent)
        dishesCollectionView.collectionViewLayout = layout
        
        dishesCollectionView.dataSource = self
        dishesCollectionView.showsVerticalScrollIndicator = false
        dishesCollectionView.showsHorizontalScrollIndicator = false
        dishesCollectionView.scrollsToTop = false
        dishesCollectionView.numberOfSets = kCollectionViewNumberOfSets
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

