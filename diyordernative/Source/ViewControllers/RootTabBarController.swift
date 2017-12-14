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
        (HomeViewController.title, HomeViewController.icon),
        (HotItemViewController.title, HotItemViewController.icon),
        (OrderViewController.title, OrderViewController.icon),
        (AccountViewController.title, AccountViewController.icon),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBar.tintColor = UIConstants.appThemeColor
        for index in 0..<tabBar.items!.count {
            let tabBarItem = tabBar.items![index]
            tabBarItem.title = tabBarTitleIcon[index].0
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
