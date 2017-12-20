//
//  OrderViewController.swift
//  
//
//  Created by Richard Lu on 2017-12-13.
//

import UIKit

class OrderViewController: BaseViewController {

    static let tabTitle = "Order"
    
    static let icon = #imageLiteral(resourceName: "icon_order")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: OrderViewController.tabTitle, image: OrderViewController.icon, tag: 2)
        self.title = OrderViewController.tabTitle
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
