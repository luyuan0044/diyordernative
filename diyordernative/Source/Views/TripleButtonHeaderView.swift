//
//  TripleButtonHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol TripleButtonHeaderViewDelegate {
    func handleOnLeftButtonTapped ()
    func handleOnMiddleButtonTapped ()
    func handleOnRightButtonTapped ()
}

class TripleButtonHeaderView: UITableViewHeaderFooterView {

    //MARK: - Properties
    
    static let key = "TripleButtonHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var middleButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: TripleButtonHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftButton.setTitleColor(.darkGray, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftButton.addTarget(self, action: #selector(onLeftButtonTapped(_:)), for: .touchUpInside)
        
        middleButton.setTitleColor(.darkGray, for: .normal)
        middleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        middleButton.addTarget(self, action: #selector(onMiddleButtonTapped(_:)), for: .touchUpInside)
        
        rightButton.setTitleColor(.darkGray, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.addTarget(self, action: #selector(onRightButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func onLeftButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnLeftButtonTapped()
    }
    
    @objc private func onMiddleButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnMiddleButtonTapped()
    }
    
    @objc private func onRightButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnRightButtonTapped()
    }
    
    func update () {
        
    }
}
