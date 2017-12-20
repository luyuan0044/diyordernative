//
//  ShoppingCartViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class ShoppingCartViewController: BaseViewController {

    // MARK: - Properties
    
    static let tabTitle = "cart"
    
    static let icon = #imageLiteral(resourceName: "icon_cart")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: ShoppingCartViewController.tabTitle, image: ShoppingCartViewController.icon, tag: 3)
        self.title = ShoppingCartViewController.tabTitle
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
