//
//  LoginViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-22.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgetButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        title = LanguageControl.shared.getLocalizeString(by: "login")
        
        usernameTextField.backgroundColor = UIColor.white
        usernameTextField.placeholder = LanguageControl.shared.getLocalizeString(by: "username")
        usernameTextField.leftViewMode = .always
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(onTextFieldTextChanged(_:)), for: .editingChanged)
        let usernameLeftView = UIImageView (image: #imageLiteral(resourceName: "icon_user").withRenderingMode(.alwaysTemplate))
        usernameLeftView.tintColor = UIColor.lightGray
        usernameLeftView.contentMode = .scaleAspectFit
        usernameLeftView.clipsToBounds = true
        usernameLeftView.frame = CGRect (x: 0, y: 0, width: 30, height: 20)
        usernameTextField.leftView = usernameLeftView
        
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.placeholder = LanguageControl.shared.getLocalizeString(by: "password")
        passwordTextField.leftViewMode = .always
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(onTextFieldTextChanged(_:)), for: .editingChanged)
        passwordTextField.isSecureTextEntry = true
        let passwordLeftView = UIImageView (image: #imageLiteral(resourceName: "icon_lock").withRenderingMode(.alwaysTemplate))
        passwordLeftView.tintColor = UIColor.lightGray
        passwordLeftView.contentMode = .scaleAspectFit
        passwordLeftView.clipsToBounds = true
        passwordLeftView.frame = CGRect (x: 0, y: 0, width: 30, height: 20)
        passwordTextField.leftView = passwordLeftView
        
        updatePasswordRightView()
        
        loginButton.setTitle(LanguageControl.shared.getLocalizeString(by: "login"), for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(onLoginButtonTapped(_:)), for: .touchUpInside)
        enableLoginButton (shouldEnable: false)
        
        forgetButton.backgroundColor = UIColor.clear
        forgetButton.setTitleColor(UIColor.gray, for: .normal)
        forgetButton.setTitle(LanguageControl.shared.getLocalizeString(by: "forget password") + "?", for: .normal)
        
        signupButton.backgroundColor = UIColor.clear
        signupButton.setTitleColor(UIColor.gray, for: .normal)
        signupButton.setTitle(LanguageControl.shared.getLocalizeString(by: "signup"), for: .normal)
        
        dismissButton.image = #imageLiteral(resourceName: "icon_cross").withRenderingMode(.alwaysTemplate)
        dismissButton.tintColor = UIColor.white
        dismissButton.target = self
        dismissButton.action = #selector(onDismissButtonTapped(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func updatePasswordRightView () {
        let passwordRightView: UIButton!
        if (passwordTextField.rightView == nil) {
            passwordTextField.rightViewMode = .always
            passwordRightView = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 40))
            passwordRightView.contentMode = .scaleAspectFit
            passwordRightView.clipsToBounds = true
            passwordRightView.addTarget(self, action: #selector(onShowHidePasswordButtonTapped(_:)), for: .touchUpInside)
            passwordTextField.rightView = passwordRightView
        } else {
            passwordRightView = passwordTextField.rightView as! UIButton
        }
        
        let image = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "icon_hide_password") : #imageLiteral(resourceName: "icon_show_password")
        passwordRightView.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        passwordRightView.tintColor = passwordTextField.isSecureTextEntry ? UIColor.lightGray : UIColor.black
    }
    
    @objc private func onShowHidePasswordButtonTapped (_ sender: AnyObject?) {
        passwordTextField.resignFirstResponder()
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        updatePasswordRightView()
    }
    
    @objc private func onTextFieldTextChanged (_ sender: UITextField) {
        let shouldEnableLoginButton = !(usernameTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty
        enableLoginButton (shouldEnable: shouldEnableLoginButton)
    }
    
    @objc private func onLoginButtonTapped (_ sender: UIButton) {
        print("Login button tapped")
    }
    
    func enableLoginButton (shouldEnable: Bool) {
        loginButton.backgroundColor = shouldEnable ? UIConstants.checkoutButtonColor : UIColor.lightGray
        let titleColor = shouldEnable ? UIColor.white : UIColor.gray
        loginButton.setTitleColor(titleColor, for: .normal)
        loginButton.isEnabled = shouldEnable
    }
    
    @objc private func onDismissButtonTapped (_ sender: AnyObject?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
