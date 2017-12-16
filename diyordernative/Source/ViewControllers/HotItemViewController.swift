//
//  HotItemViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UtilityButtonsHeaderViewDelegate {

    // MARK: - Properties
    
    static let title = "Hot"
    
    static let icon = #imageLiteral(resourceName: "icon_hot")
    
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    var hotItemCategories: [HotItemCategory]? = nil
    
    var hotItems: [HotItem]? = nil
    
    var colletionViewDisplayStyle: colletionViewDisplayStyle = .grid
    
    let hotItemPadding: CGFloat = 5
    
    var numberOfItemPerLine: CGFloat { get { return colletionViewDisplayStyle == .grid ? 2 : 1 } }
    
    let heightOfHeader: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HotItemViewController.title, image: HotItemViewController.icon, tag: 1)
        
        hotItemCollectionView.register(HotItemCategoryHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HotItemCategoryHeaderView.key)
        hotItemCollectionView.register(UtilityButtonsHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UtilityButtonsHeaderView.key)
        hotItemCollectionView.register(CollectionLoadingFooterView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionLoadingFooterView.key)
        hotItemCollectionView.register(GridProductCell.nib, forCellWithReuseIdentifier: GridProductCell.key)
        
        hotItemCollectionView.dataSource = self
        hotItemCollectionView.delegate = self
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func fetch () {
        DispatchQueue.global(qos: .userInitiated).async {
            HotItemLoader.startRequestHotItemCategory(completion: {
                _status, items in
                
                if _status == .success {
                    self.hotItemCategories = items
                }
                
                DispatchQueue.main.async {
                    self.refreshHotItemCollectionView()
                }
            })
        }
    }
    
    func refreshHotItemCollectionView () {
        hotItemCollectionView.reloadData()
        hotItemCollectionView.layoutIfNeeded()
    }
    
    // MARKL - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.key, for: indexPath) as! GridProductCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.key, for: indexPath) as! GridProductCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotItems == nil ? 1 : hotItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HotItemCategoryHeaderView.key, for: indexPath) as! HotItemCategoryHeaderView
                
                view.update(hotItemCategories: self.hotItemCategories)
                
                return view
            } else {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UtilityButtonsHeaderView.key, for: indexPath) as! UtilityButtonsHeaderView
                view.delegate = self
                view.setup()
                
                return view
            }
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLoadingFooterView.key, for: indexPath)
            
            return view
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: collectionView.frame.width, height: 0.1)
        } else {
            let interItemSpace = (numberOfItemPerLine - 1) * hotItemPadding
            let itemWidth: CGFloat = (collectionView.frame.width - interItemSpace) / numberOfItemPerLine
            let itemHeight: CGFloat = itemWidth * 1.5
            return CGSize (width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return hotItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return hotItemPadding / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets (top: 0, left: 0, bottom: hotItemPadding, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize (width: collectionView.frame.width, height: heightOfHeader)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize (width: collectionView.frame.width, height: 0.1)
        } else {
            return CGSize (width: collectionView.frame.width, height: heightOfHeader)
        }
    }
    
    // MARK: - UtilityButtonsHeaderViewDelegate
    
    func onFirstButtonTapped() {
        
    }
    
    func onSecondButtonTapped() {
        
    }
    
    func onSquareButtonTapped() {
        
    }
    
    func onRightButtonTapped() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
