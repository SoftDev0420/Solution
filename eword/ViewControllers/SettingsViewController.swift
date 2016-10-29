//
//  SettingsViewController.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var rushText: UILabel!
    @IBOutlet weak var eFileText: UILabel!
    
    var isRush: Bool = false, isEFile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden: Bool {
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

    ////////////////////////////////
    
    //  UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == userName) {
            password.becomeFirstResponder()
        }
        else if (textField == password) {
            view.endEditing(true)
        }
        return false
    }
    
    
    @IBAction func onRememberMe(_ sender: AnyObject) {
        checkImage.isHidden = !checkImage.isHidden
    }
    
    @IBAction func onRush(_ sender: AnyObject) {
        isRush = !isRush
        if (isRush) {
            rushText.text = "  Yes"
        }
        else {
            rushText.text = "  No"
        }
    }
    
    @IBAction func onEFile(_ sender: AnyObject) {
        isEFile = !isEFile
        if (isEFile) {
            eFileText.text = "  Yes"
        }
        else {
            eFileText.text = "  No"
        }
    }
    
    @IBAction func onSignIn(_ sender: AnyObject) {
        if (userName.text == "" || password.text == "") {
            Util.showAlertMessage(title: "Card Reader", message: "Username or Password is not valid.\nPlease re-enter them.", parent: self)
        }
        else {
            
        }
    }
}
