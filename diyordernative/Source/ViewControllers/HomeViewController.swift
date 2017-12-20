//
//  ViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class HomeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    static let tabTitle = "home"
    
    static let icon = #imageLiteral(resourceName: "icon_home")
    
    var bannerItems: [BannerItem] = []
    
    var storeCategoryItems: [StoreCategory] = []
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var topCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    let bannerItemPadding: CGFloat = 5
    
    let numberOfStoreCategoryItemsPerLine: CGFloat = 5
    
    let heightOfSingleLineOfStoreCategoryItems: CGFloat = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HomeViewController.tabTitle, image: HomeViewController.icon, tag: 0)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.showsVerticalScrollIndicator = false
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(onRightButtonItemTapped(_:))
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    /**
     Fetch data of banner items and store category array
     */
    func fetch ()
    {
        bannerItems = []
        storeCategoryItems = []
        
        let taskGroup = DispatchGroup ()
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            BannerItemLoader.startRequestBannerItem(completion: {
                _status, items in
                
                if _status == .success {
                    self.bannerItems.append(contentsOf: items!)
                    self.sortBannerItemForDisplay()
                }
                
                DispatchQueue.main.async {
                    self.refreshBannerItemCollectionView()
                }
                
                taskGroup.leave()
            })
            
            taskGroup.enter()
            StoreCategoryLoader.startRequestStoreCategory (completion: {
                _status, items in
                
                if _status == .success {
                    self.storeCategoryItems.append(contentsOf: items!)
                }
                
                DispatchQueue.main.async {
                    self.refreshStoreCategoryCollectionView()
                    
                    self.topCollectionViewHeightConstraint.constant = self.topCollectionView.contentSize.height
                }
                
                taskGroup.leave()
            })
        }
    }
    
    /**
     Refresh banner item collection view
     */
    func refreshBannerItemCollectionView () {
        bottomCollectionView.reloadData()
        bottomCollectionView.layoutIfNeeded()
    }
    
    /**
     Refresh store category item collection view
     */
    func refreshStoreCategoryCollectionView () {
        topCollectionView.reloadData()
        topCollectionView.layoutIfNeeded()
    }
    
    /**
     Right button item tap event handler
     */
    @objc private func onRightButtonItemTapped (_ sender: AnyObject?) {
        let languages = LanguageControl.shared.getAvaliableAppLanguages();
        LanguageControl.shared.setAppLanguage(languages[0])
        fetch()
    }
    
    /**
     Sort array of banner items to fit collection view display
     */
    func sortBannerItemForDisplay () {
        var result: [BannerItem] = []
        var shouldFindLast = false
        var lastHalfWidthItemIdx = 0
        for idx in 0..<bannerItems.count {
            let item = bannerItems[idx]
            if item.getBannerDisplayWidth() == .half {
                if !shouldFindLast {
                    result.append(item)
                    lastHalfWidthItemIdx = result.count - 1
                } else {
                    result.insert(item, at: lastHalfWidthItemIdx + 1)
                }
                shouldFindLast = !shouldFindLast
            } else {
                result.append(item)
            }
        }
        self.bannerItems = result
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bottomCollectionView {
            return bannerItems.count
        }
        else {
            return storeCategoryItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        
        if collectionView == bottomCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerItemCell.key, for: indexPath)
            
            let bannerItem = bannerItems[indexPath.row]
            (cell as! BannerItemCell).update(item: bannerItem)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCategoryCell.key, for: indexPath)
            
            let storeCategoryItem = storeCategoryItems[indexPath.row]
            (cell as! StoreCategoryCell).update(storeCategory: storeCategoryItem)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bottomCollectionView {
            let bannerItem = bannerItems[indexPath.row]
            let itemHeight = collectionView.frame.width * 0.4
            let displayWidth = bannerItem.getBannerDisplayWidth()
            var numberOfItemPerLine = 2
            if displayWidth == bannerDisplayWidth.full {
                numberOfItemPerLine = 1
            }
            let itemWidth = (collectionView.frame.width - CGFloat(numberOfItemPerLine + 1) * bannerItemPadding) / CGFloat(numberOfItemPerLine)
            
            return CGSize (width: itemWidth, height: itemHeight)
        } else {
            let itemWidth = collectionView.frame.width / numberOfStoreCategoryItemsPerLine
            let itemHeight = heightOfSingleLineOfStoreCategoryItems
            
            return CGSize (width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == bottomCollectionView {
            return UIEdgeInsets (top: bannerItemPadding, left: bannerItemPadding, bottom: bannerItemPadding, right: bannerItemPadding)
        } else {
            return UIEdgeInsets (top: 0, left: 0, bottom: bannerItemPadding, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bottomCollectionView {
            return bannerItemPadding
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bottomCollectionView {
            return bannerItemPadding
        } else {
            return 0
        }
    }
}

