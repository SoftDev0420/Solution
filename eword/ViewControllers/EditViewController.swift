//
//  EditViewController.swift
//  eword
//
//  Created by Admin on 01/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class EditViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var status: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).getManagedObjectContext()
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////
    
    func reload() {
        length.text = Util.timeForTicks(record!.length!.doubleValue)
        if (record!.submitted!.intValue == 1) {
            status.text = "Submitted"
        }
        else {
            status.text = "Not Submitted"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        date.text = dateFormatter.string(from: record!.date!)
    }
    
    ////////////////////////////////
    
    @IBAction func onEdit(_ sender: Any) {
        let secondTabNavigationController = tabBarController!.viewControllers![0] as! UINavigationController
        secondTabNavigationController.popToRootViewController(animated: true)
        let recordViewController = secondTabNavigationController.viewControllers[0] as! RecordViewController
        recordViewController.isEdit = true
        recordViewController.recording = record
        tabBarController!.selectedIndex = 0
        navigationController!.popViewController(animated: false)
    }
    
    @IBAction func onEmail(_ sender: Any) {
        if (MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setMessageBody("The audio file is attached in this mail.", isHTML: false)
            let path = DirectoryManager.instance.getPathForFileWithType(type: KFolder, name: record!.fileName!)
            let data = NSData(contentsOfFile: path)
            mailComposer.addAttachmentData(data as! Data, mimeType: "audio/mp4a-latm", fileName: record!.fileName!)
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if (record!.submitted!.intValue == 0) {
            let secondTabNavigationController = tabBarController!.viewControllers![2] as! UINavigationController
            secondTabNavigationController.popToRootViewController(animated: true)
            let settingsViewController = secondTabNavigationController.viewControllers[0] as! SettingsViewController
            let path = DirectoryManager.instance.getPathForFileWithType(type: KFolder, name: record!.fileName!)
            let url = URL(fileURLWithPath: path)
            settingsViewController.urlSelectedFile = url
            tabBarController!.selectedIndex = 2
            navigationController!.popViewController(animated: false)
        }
        else {
            Util.showAlertMessage(title: "Eword", message: "File is already submitted.", parent: self)
        }
    }

    @IBAction func onDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Eword", message: "Want to delete this file?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            DirectoryManager.instance.deleteFileAtPath(folderName: KFolder, fileName: self.record!.fileName!)
            self.deleteFromCoreDataWithName(name: self.record!.fileName!)
            self.setBadge()
            self.navigationController!.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    ////////////////////////////////
    
    func setBadge() {
        let fetchRequest = NSFetchRequest<Record>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext!)
        fetchRequest.includesSubentities = false
        do {
            let count = try managedObjectContext!.count(for: fetchRequest)
            if (count > 0) {
                tabBarController!.tabBar.items![1].badgeValue = String(count)
            }
            else {
                tabBarController!.tabBar.items![1].badgeValue = nil
            }
        }
        catch {
            
        }
    }
    
    func deleteFromCoreDataWithName(name: String) {
        let fetchRequest = NSFetchRequest<Record>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext!)
        fetchRequest.predicate = NSPredicate.init(format: "fileName = %@", name)
        do {
            let results = try managedObjectContext!.fetch(fetchRequest) as [Record]
            let record = results.last
            if (record != nil) {
                managedObjectContext!.delete(record!)
                do {
                    try managedObjectContext!.save()
                }
                catch {
                    
                }
            }
        }
        catch {
            
        }
    }
}
