//
//  StoreViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-15.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    var id: String!
    
    var store: Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func setId (_ id: String) {
        self.id = id
    }
    
    func setStore (_ store: Store) {
        self.id = store.id
        self.store = store
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
