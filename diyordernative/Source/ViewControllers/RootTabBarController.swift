//
//  RootTabBarController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    let tabBarTitleIcon: Array<(String, UIImage)> = [
        (HomeViewController.tabTitle, HomeViewController.icon),
        (HotItemViewController.tabTitle, HotItemViewController.icon),
        (BarcodeReaderViewController.tabTitle, BarcodeReaderViewController.icon),
        (ShoppingCartViewController.tabTitle, ShoppingCartViewController.icon),
        (AccountViewController.tabTitle, AccountViewController.icon),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBar.tintColor = UIConstants.appThemeColor
        for index in 0..<tabBar.items!.count {
            let tabBarItem = tabBar.items![index]
            tabBarItem.title = LanguageControl.shared.getLocalizeString(by: tabBarTitleIcon[index].0)
            tabBarItem.image = tabBarTitleIcon[index].1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
