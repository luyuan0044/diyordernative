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

class HomeViewController: BaseViewController {
    
    static let title = "Home"
    
    static let icon = #imageLiteral(resourceName: "icon_home")
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HomeViewController.title, image: HomeViewController.icon, tag: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fetch data for view controller from server
    func fetch ()
    {
        let taskGroup = DispatchGroup ()
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
        }
        
        taskGroup.leave()
    }
}

