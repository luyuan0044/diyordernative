//
//  SettingViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-22.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class SettingViewController: BaseTableViewController {
    
    var tableViewSource: [[String]] = [
        ["change language",
         "change password"],
        ["notification",
         "clear cache"],
        ["Touch ID",
         "merchant settings"],
        ["about goopter",
         "feedback",
         "term of use"],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        hidesBottomBarWhenPushed = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return super.numberOfSections(in: tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
