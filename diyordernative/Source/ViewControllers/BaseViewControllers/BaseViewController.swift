//
//  BaseViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var utilsPopupViewController: UtilsPopupViewController? = nil
    
    var utilsPopupViewItems: [UtilsPopupItem]? { get { return nil } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentUtilsPopupViewController () {
        guard let items = utilsPopupViewItems else {
            return
        }
        
        if utilsPopupViewController == nil {
            utilsPopupViewController = UtilsPopupViewController()
            utilsPopupViewController!.modalTransitionStyle = .crossDissolve
            utilsPopupViewController!.modalPresentationStyle = .overFullScreen
        }
        
        utilsPopupViewController!.setViewItems(items: items)
        present(utilsPopupViewController!, animated: true, completion: nil)
    }
    
    func dismissUtilsPopupViewController (completion: (() -> Void)? = nil) {
        guard let viewController = utilsPopupViewController else {
            return
        }
        
        viewController.dismiss(animated: true, completion: completion)
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
