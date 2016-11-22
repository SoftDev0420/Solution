//
//  SettingsViewController.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var rushText: UILabel!
    @IBOutlet weak var eFileText: UILabel!
    
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    let screenHeight = UIScreen.main.bounds.height
    
    var loadingIndicator: MBProgressHUD?
    
    let userDefaults = UserDefaults.standard
    var urlSelectedFile: URL?
    var isRush: Bool = false, isEFile: Bool = false
    var alreadySubmitted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (userDefaults.bool(forKey: "isTick")) {
            userName.text = userDefaults.string(forKey: "userName")
            password.text = userDefaults.string(forKey: "password")
            checkImage.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object:nil)
        
        let singleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(SettingsViewController.onCloseKeyboard))
        singleTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapGesture)
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

    func isInternetAvailable() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        if (reachability.currentReachabilityStatus() != NotReachable) {
            return true
        }
        if (reachability.connectionRequired() || reachability.currentReachabilityStatus() == NotReachable) {
            return false
        }
        else if (reachability.currentReachabilityStatus() == ReachableViaWiFi || reachability.currentReachabilityStatus() == ReachableViaWWAN) {
            return true
        }
        else {
            return false
        }
    }
    
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
    
    func onCloseKeyboard() {
        view.endEditing(true)
    }
    
    ////////////////////////////////
    
    //  UIKeyboardDidShowNotification
    
    func keyboardWillAppear(_ notification: Notification) {
        let keyboardInfo = (notification as NSNotification).userInfo!
        let keyboardFrameBegin: CGRect = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardFrameBegin.size.height
        
        if (500 > screenHeight - keyboardHeight) {
            mainViewTopConstraint.constant = -500 + (screenHeight - keyboardHeight)
            mainViewBottomConstraint.constant = -500 + (screenHeight - keyboardHeight)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        mainViewTopConstraint.constant = 0
        mainViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    ////////////////////////////////
    
    @IBAction func onRememberMe(_ sender: AnyObject) {
        checkImage.isHidden = !checkImage.isHidden
        userDefaults.set(!checkImage.isHidden, forKey: "isTick")
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
            Util.showAlertMessage(title: "Eword", message: "Username or Password is not valid.\nPlease re-enter them.", parent: self)
        }
        else {
            saveSettings()
            if (urlSelectedFile != nil) {
                if (alreadySubmitted == false) {
                    if (isInternetAvailable()) {
                        loadingIndicator = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                        loadingIndicator!.mode = MBProgressHUDMode.indeterminate
                        loadingIndicator!.label.text = "Loading..."
                        
                        let ws = EwordWebService()
                        ws!.baseUrl = "https://client.ewordsolutions.com"
                        ws!.httpTimeout = 3000
                        DispatchQueue.global(qos: .default).async {
                            do {
                                let rs = try ws!.userAuth(self.userName.text, userPass: self.password.text, appId: DataClass.instance.AppId)
                                if (rs.authToken != "-9999" || rs.message != "Login FAILED") {
                                    DispatchQueue.main.async {
                                        self.loadingIndicator!.label.text = "Uploading File..."
                                        self.loadingIndicator!.progress = 0
                                        DispatchQueue.global(qos: .default).async {
                                            var chunkSize: Double = 1024 * 400
                                            do {
                                                let fileSize = try (FileManager.default.attributesOfItem(atPath: self.urlSelectedFile!.path)[FileAttributeKey.size] as! NSNumber).uint64Value
                                                let autoSize = ceil(Double(fileSize / 10))
                                                if (autoSize < chunkSize) {
                                                    chunkSize = autoSize
                                                }
                                                let totalChunks = ceil(Double(fileSize) / (chunkSize * 1.0))
                                                var chunckCount = 0
                                                print("File Size = \(fileSize)")
                                                print("File Size = \(totalChunks)")
                                                
                                                let fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, self.urlSelectedFile!.path as CFString!, CFURLPathStyle.cfurlposixPathStyle, false)
                                                var readStream: CFReadStream?
                                                if (fileURL != nil) {
                                                    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL!)
                                                }
                                                
                                                var didSucceed = false
                                                if (readStream != nil) {
                                                    didSucceed = CFReadStreamOpen(readStream!)
                                                }
                                                
                                                if (!didSucceed) {
                                                    return
                                                }
                                                var streamStatus: CFStreamStatus?
                                                var attempts = 0
                                                repeat {
                                                    sleep(1)
                                                    streamStatus = CFReadStreamGetStatus(readStream!)
                                                    if (attempts > 10) {
                                                    }
                                                    attempts = attempts + 1
                                                } while ((streamStatus != .open) && (streamStatus != .error))
                                                if (streamStatus == .error) {
                                                    return
                                                }
                                                
                                                // Use default value for the chunk size for reading data.
                                                
                                                let chunkSizeForReadingData = chunkSize
                                                var hasMoreData = true
                                                var data: NSData?
                                                var data_as_hex: String?
                                                var fhash: String?
                                                var ordStatus: String?
                                                var ord_rs: EwordWebService_SubmitOrderResponse?
                                                var buffer = [UInt8](repeating: 0, count: Int(chunkSizeForReadingData))
                                                var readBytesCount = 0
                                                var sendFileName: String?
                                                var totalExecutionTime: TimeInterval = 0
                                                while (hasMoreData) {
                                                    sendFileName = self.urlSelectedFile!.lastPathComponent
                                                    autoreleasepool {
                                                        readBytesCount = CFReadStreamRead(readStream!, &buffer, buffer.count * MemoryLayout<UInt8>.size as CFIndex)
                                                    }
                                                    if (readBytesCount == -1) {
                                                        break
                                                    }
                                                    else if (readBytesCount == 0) {
                                                        hasMoreData = false
                                                    }
                                                    else {
                                                        chunckCount = chunckCount + 1
                                                        let methodStart = Date()
                                                        autoreleasepool {
                                                            data = NSData.init(bytes: buffer, length: buffer.count * MemoryLayout<UInt8>.size)
                                                            data_as_hex = data!.hexString()
                                                            fhash = data!.md5HexDigest()
                                                        }
                                                        let methodFinish = Date()
                                                        let executionTime = methodFinish.timeIntervalSince(methodStart)
                                                        print(executionTime)
                                                        print("Chunk Hash = \(fhash)")
                                                        
                                                        //  Send the chunk to Eword
                                                        var retryCount: UInt32 = 0
                                                        ordStatus = "Unsent"
                                                        repeat {
                                                            if (retryCount > 5) {
                                                                sleep(retryCount - 5)
                                                            }
                                                            let methodStart = Date()
                                                            autoreleasepool {
                                                                do {
                                                                    ord_rs = try ws!.submitOrder(rs.authToken, fileName: sendFileName! + ".caf", fileContent: data_as_hex!, chunkCount: chunckCount as NSNumber!, totalCunks: totalChunks as NSNumber!, chunkHash: fhash, isRush: self.isRush as NSNumber!, isEfile: self.isEFile as NSNumber!, appId: DataClass.instance.AppId)
                                                                    
                                                                    if (ord_rs!.status == "ExpiredToken") {
                                                                        print("Expired token should exit.")
                                                                        retryCount = 10
                                                                        DispatchQueue.global(qos: .default).async {
                                                                            self.loadingIndicator!.hide(animated: true)
                                                                            Util.showAlertMessage(title: "Eword", message: "File upload failed Auth Token Expired.", parent: self)
                                                                        }
                                                                    }
                                                                    else {
                                                                        DispatchQueue.main.async {
                                                                            var updateCount = 0
                                                                            if (Double(chunckCount) < totalChunks) {
                                                                                updateCount = chunckCount + 1
                                                                            }
                                                                            else {
                                                                                updateCount = chunckCount
                                                                            }
                                                                            self.loadingIndicator!.progress = (Float(updateCount) / Float(totalChunks))
                                                                        }
                                                                    }
                                                                    
                                                                    if (chunckCount == Int(totalChunks)) {
                                                                        DispatchQueue.main.async {
                                                                            self.loadingIndicator?.hide(animated: true)
                                                                            if (ord_rs!.orderID.range(of: "_") != nil)
                                                                            {
                                                                                Util.showAlertMessage(title: "Eword", message: ord_rs!.orderID + " Order Complete.", parent: self)
                                                                            }
                                                                            self.isRush = false
                                                                            self.isEFile = false
                                                                            self.rushText.text = " No"
                                                                            self.eFileText.text = " No"
                                                                            self.saveInCoreData()
                                                                        }
                                                                    }
                                                                }
                                                                catch {
                                                                    ordStatus = "SoapError"
                                                                    DispatchQueue.global(qos: .default).async {
                                                                        self.loadingIndicator!.hide(animated: true)
                                                                        Util.showAlertMessage(title: "Eword", message: "Data uploading failed", parent: self)
                                                                    }
                                                                }
                                                            }
                                                            let methodFinish = Date()
                                                            let executionTime = methodFinish.timeIntervalSince(methodStart)
                                                            totalExecutionTime = totalExecutionTime + executionTime
                                                            print(executionTime)
                                                            retryCount = retryCount + 1
                                                        } while (ordStatus == "HashMissMatch" && retryCount < 10)
                                                        if (retryCount > 9) {
                                                            hasMoreData = false
                                                            DispatchQueue.global(qos: .default).async {
                                                                self.loadingIndicator!.hide(animated: true)
                                                                Util.showAlertMessage(title: "Eword", message: "Data uploading failed.", parent: self)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            catch {
                                                
                                            }
                                        }
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        self.loadingIndicator!.hide(animated: true)
                                        Util.showAlertMessage(title: "Eword", message: "Login Failed. \nPlease check your username and password.", parent: self)
                                    }
                                }
                            }
                            catch {
                                let sr = (error as NSError).userInfo["soapResponse"] as! SoapResponse
                                print(sr.rawHttpResponse)
                                DispatchQueue.global(qos: .default).async {
                                    self.loadingIndicator!.hide(animated: true)
                                    Util.showAlertMessage(title: "Eword", message: "Login failed.", parent: self)
                                }
                            }
                        }
                    }
                    else {
                        Util.showAlertMessage(title: "Eword", message: "Network is not reachable.", parent: self)
                    }
                }
                else {
                    Util.showAlertMessage(title: "Eword", message: "File is already submitted.", parent: self)
                }
            }
            else {
                Util.showAlertMessage(title: "Eword", message: "No files are attached.", parent: self)
            }
        }
    }
    
    ////////////////////////////////
    
    func saveSettings() {
        if (!checkImage.isHidden) {
            userDefaults.set(userName.text, forKey: "userName")
            userDefaults.set(password.text, forKey: "password")
        }
    }
    
    func saveInCoreData() {
        alreadySubmitted = false
        let context = (UIApplication.shared.delegate as! AppDelegate).getManagedObjectContext()
        let record = updateIfEditWith(context: context!)
        if (record != nil) {
            record!.setValue(1, forKey: "submitted")
        }
        
        do {
            try context!.save()
        }
        catch {
            print("Can't save.")
        }
        
    }
    
    func updateIfEditWith(context: NSManagedObjectContext) -> Record? {
        let name = urlSelectedFile!.lastPathComponent
        let feedFetch = NSFetchRequest<Record>.init(entityName: "Record")
        let predicate = NSPredicate.init(format: "fileName = %@" , name)
        feedFetch.predicate = predicate
        do {
            let results = try context.fetch(feedFetch) as [Record]
            return results.last
        }
        catch {
            return nil
        }
    }
    
    ////////////////////////////////
}
