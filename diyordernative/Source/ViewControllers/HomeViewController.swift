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
    
    static let title = "Home"
    
    static let icon = #imageLiteral(resourceName: "icon_home")
    
    var bannerItems: [BannerItem] = []
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    let bannerItemPadding: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HomeViewController.title, image: HomeViewController.icon, tag: 0)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
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
        let taskGroup = DispatchGroup ()
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            
            BannerItemLoader.startRequestBannerItem(completion: {
                _status, items in
                
                if _status == .success {
                    self.bannerItems.append(contentsOf: items!)
                }
                
                DispatchQueue.main.async {
                    self.refreshBannerItemCollectionView()
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
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerItemCell.key, for: indexPath) as! BannerItemCell
        
        let bannerItem = bannerItems[indexPath.row]
        cell.update(item: bannerItem)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bannerItem = bannerItems[indexPath.row]
        let itemHeight = collectionView.frame.width * 0.4
        let numberOfItemPerLine = 4 / bannerItem.width
        let itemWidth = collectionView.frame.width - CGFloat(numberOfItemPerLine + 1) * bannerItemPadding
        
        return CGSize (width: itemWidth, height: itemHeight)
    }
}

