//
//  RightSlideFilterViewController.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-17.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

protocol RightSlideFilterViewControllerDelegate {
    func onHideButtonTapped ()
    func onResetButtonTapped ()
    func onConfirmButtonTapped ()
}

class RightSlideFilterViewController: UIViewController {

    @IBOutlet weak var rightBackgroundView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var hideButton: UIButton!
    
    var delegate: RightSlideFilterViewControllerDelegate?
    
    var tableViewDataSource: UITableViewDataSource?
    
    var tableViewDelegate: UITableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.clear
        
        rightBackgroundView.backgroundColor = UIColor.white
        
        confirmButton.backgroundColor = UIConstants.appThemeColor
        confirmButton.setTitle(LanguageControl.shared.getLocalizeString(by: "confirm"), for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(onConfirmButtonTapped(_:)), for: .touchUpInside)
        
        resetButton.backgroundColor = UIConstants.appThemeColor.withAlphaComponent(0.6)
        resetButton.setTitle(LanguageControl.shared.getLocalizeString(by: "reset"), for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.addTarget(self, action: #selector(onResetButtonTapped(_:)), for: .touchUpInside)
        
        hideButton.backgroundColor = UIConstants.transparentBlackColor
        hideButton.addTarget(self, action: #selector(onHideButtonTapped(_:)), for: .touchUpInside)
        
        filterTableView.dataSource = tableViewDataSource
        filterTableView.delegate = tableViewDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Implementation
    
    @objc private func onConfirmButtonTapped (_ sender: AnyObject?) {
        delegate?.onConfirmButtonTapped()
    }
    
    @objc private func onResetButtonTapped (_ sender: AnyObject?) {
        delegate?.onResetButtonTapped()
    }
    
    @objc private func onHideButtonTapped (_ sender: AnyObject?) {
        delegate?.onHideButtonTapped()
    }
    
    func setTableViewDataSourceAndDelegate (dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableViewDataSource = dataSource
        tableViewDelegate = delegate
        
        if filterTableView != nil {
            filterTableView.dataSource = tableViewDataSource
            filterTableView.delegate = tableViewDelegate
            
            refreshData()
        }
    }
    
    func refreshData () {
        filterTableView.reloadData()
        filterTableView.layoutIfNeeded()
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
