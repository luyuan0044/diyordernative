//
//  StoreViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-15.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageViewMask: UIView!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var rightBarButtonItem: UIBarButtonItem!
    
    var id: String!
    
    var store: Store?
    
    let defaultBackgroundImage = StoreCategoryControl.shared.defaultStoreCategoryImageLarge

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //backgroundImageViewMask.backgroundColor = UIColor.black//.withAlphaComponent(0.1)
        
        backgroundImageView.image = defaultBackgroundImage
        if store != nil, let imageUrl = store!.imageUrl {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: backgroundImageView.frame.size)!
            if let url = URL (string: urlStr) {
                backgroundImageView.sd_setImage(with: url, placeholderImage: defaultBackgroundImage)
            }
            contentTableView.delegate = self
            contentTableView.dataSource = self
        } else {
            // load data
        }
        
        rightBarButtonItem = UIBarButtonItem (image: #imageLiteral(resourceName: "icon_dots").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleOnRightBarButtonItemTapped(_:)))
        rightBarButtonItem.tintColor = UIColor.white
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
        contentTableView.register(StoreHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoreHeaderView.key)
        contentTableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Implementation
    
    func setId (_ id: String) {
        self.id = id
    }
    
    func setStore (_ store: Store) {
        self.id = store.id
        self.store = store
    }
    
    @objc func handleOnRightBarButtonItemTapped (_ sender: AnyObject?) {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreHeaderView.key) as! StoreHeaderView
        
        header.backgroundColor = UIColor.clear
        header.update(store: self.store!)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
