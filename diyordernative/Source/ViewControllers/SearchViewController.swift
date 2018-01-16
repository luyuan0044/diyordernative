//
//  SearchViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-15.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let navBarColor = UIColor (red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationController?.navigationBar.barTintColor = navBarColor
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
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
