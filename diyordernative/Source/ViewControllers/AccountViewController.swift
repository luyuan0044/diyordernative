//
//  AccountViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    static let tabTitle = "account"
    
    static let icon = #imageLiteral(resourceName: "icon_account")
    
    @IBOutlet weak var accountTableView: UITableView!
    
    @IBOutlet weak var settingButtonItem: UIBarButtonItem!
    
    var backgroundView: UIView!
    
    var headerHelperView: UIView!
    
    let segmentCellHeight: CGFloat = 75
    
    let contentColor = UIColor.gray
    
    let textColor = UIColor.darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: AccountViewController.tabTitle, image: AccountViewController.icon, tag: 4)
        self.title = LanguageControl.shared.getLocalizeString(by: AccountViewController.tabTitle)
        
        accountTableView.dataSource = self
        accountTableView.delegate = self
        accountTableView.separatorStyle = .none
        
        settingButtonItem.image = #imageLiteral(resourceName: "icon_setting").withRenderingMode(.alwaysTemplate)
        settingButtonItem.tintColor = UIColor.white
        
        backgroundView = UIView ()
        backgroundView.backgroundColor = UIColor.groupTableViewBackground
        accountTableView.backgroundView = backgroundView
        
        headerHelperView = UIView(frame: CGRect(x: 0, y: 0, width: accountTableView.frame.width, height: accountTableView.frame.width))
        headerHelperView.backgroundColor = UIConstants.appThemeColor
        accountTableView.backgroundView?.addSubview(headerHelperView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func getNormalCell (icon: UIImage, title: String) -> UITableViewCell {
        var cell = accountTableView.dequeueReusableCell(withIdentifier: "NormalCell")
        
        if cell == nil {
            cell = UITableViewCell (style: .default, reuseIdentifier: "NormalCell")
        }
        
        cell!.imageView?.image = icon.withRenderingMode(.alwaysTemplate)
        cell!.imageView?.tintColor = contentColor
        
        cell!.textLabel?.text = LanguageControl.shared.getLocalizeString(by: title)
        cell!.textLabel?.textColor = textColor
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell!.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountHeaderCell.key) as! AccountHeaderCell
                
                cell.update(isLogin: true)
                cell.selectionStyle = .none
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountSegmentCell.key) as! AccountSegmentCell
                
                cell.selectionStyle = .none
                cell.update(contentColor: contentColor)
                
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_book"), title: "address book")
            } else {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_recent"), title: "recently viewed")
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_giftcard"), title: "gift cards")
            } else {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_bell"), title: "notifications")
            }
        } else {
            if indexPath.row == 0 {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_thumb"), title: "rate goopter")
            } else {
                return getNormalCell (icon: #imageLiteral(resourceName: "icon_recent"), title: "privacy policy")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            } else {
                return segmentCellHeight
            }
        } else {
            return UIConstants.tableViewDefaultCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewDefaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        if section == 0 {
            view.backgroundColor = UIColor.clear
        } else {
            view.backgroundColor = UIColor.groupTableViewBackground
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 100
        } else {
            return 10
        }
    }
    
    // MARK: - UITableViewDelegate

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
