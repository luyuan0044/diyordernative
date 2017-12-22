//
//  ShoppingCartViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class ShoppingCartViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ShoppingCartCheckoutCellDelegate {
    
    // MARK: - Properties
    
    static let tabTitle = "cart"
    
    static let icon = #imageLiteral(resourceName: "icon_cart")
    
    @IBOutlet weak var manageButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var managePanelView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cartTableView: UITableView!
    
    var isManagePanelViewShowed = false
    
    let managePanelViewDisplacement: CGFloat = 45
    
    let contentColor = UIColor.gray
    
    @IBOutlet weak var managePanelViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: ShoppingCartViewController.tabTitle, image: ShoppingCartViewController.icon, tag: 3)
        self.title = LanguageControl.shared.getLocalizeString(by: ShoppingCartViewController.tabTitle)
        
        manageButtonItem.title = LanguageControl.shared.getLocalizeString(by: "manage")
        manageButtonItem.tintColor = UIColor.white
        manageButtonItem.target = self
        manageButtonItem.action = #selector(onManageButtonItemTapped(_:))
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        deleteButton.backgroundColor = UIColor.white
        deleteButton.setTitle(LanguageControl.shared.getLocalizeString(by: "delete"), for: .normal)
        deleteButton.setTitleColor(UIConstants.appThemeColor, for: .normal)
        deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.layer.borderColor = UIConstants.appThemeColor.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsets (top: 10, left: 15, bottom: 10, right: 15)
        deleteButton.layer.borderWidth = 0.5
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTapped(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    @objc private func onManageButtonItemTapped (_ sender: AnyObject?) {
        if isManagePanelViewShowed {
            hideManagePanelView()
        } else {
            showManagePanelView()
        }
    }
    
    func showManagePanelView () {
        if isManagePanelViewShowed {
            return
        }
        
        isManagePanelViewShowed = !isManagePanelViewShowed
        
        UIView.animate(withDuration: 0.2, animations: {
            self.managePanelViewTopConstraint.constant += self.managePanelViewDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    func hideManagePanelView () {
        if !isManagePanelViewShowed {
            return
        }
        
        isManagePanelViewShowed = !isManagePanelViewShowed
        
        UIView.animate(withDuration: 0.2, animations: {
            self.managePanelViewTopConstraint.constant -= self.managePanelViewDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func onDeleteButtonTapped (_ sender: AnyObject?) {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "StoreHeaderCell")
            
            if cell == nil {
                cell = UITableViewCell (style: .default, reuseIdentifier: "StoreHeaderCell")
            }
            
            cell!.imageView?.image = #imageLiteral(resourceName: "icon_store").withRenderingMode(.alwaysTemplate)
            cell!.imageView?.tintColor = contentColor
            cell!.textLabel?.text = "Store name"
            cell!.textLabel?.textColor = contentColor
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell!.accessoryType = .disclosureIndicator
            cell!.selectionStyle = .none
            
            return cell!
        } else if indexPath.row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "StoreHeaderCell")
            
            if cell == nil {
                cell = UITableViewCell (style: .default, reuseIdentifier: "StoreHeaderCell")
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCheckoutCell.key) as! ShoppingCartCheckoutCell
            
            cell.delegate = self
            cell.update(subtotal: 12.6, contentColor: contentColor)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    // MARK: - ShoppingCartCheckoutCellDelegate
    
    func onCheckoutButtonTapped() {
        
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
