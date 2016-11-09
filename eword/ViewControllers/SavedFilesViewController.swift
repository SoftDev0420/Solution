//
//  SavedFilesViewController.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

let KToday = "today"
let KlastWeek = "lastWeek"
let KOld = "old"
let KAll = "all"

import UIKit
import CoreData

class SavedFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recordTableView: UITableView!
    
    var leftButton: UIBarButtonItem?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).getManagedObjectContext()
    
    var todayArray = [Record]()
    var lastWeekArray = [Record]()
    var olderArray = [Record]()
    var isTableViewEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEdit))
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
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
    
    //  NavigationBar
    
    func onEdit() {
        isTableViewEditing = !isTableViewEditing
        recordTableView.isEditing = isTableViewEditing
        if (isTableViewEditing) {
            leftButton!.title = "Done"
        }
        else {
            leftButton!.title = "Edit"
        }
    }

    ////////////////////////////////
    
    //  UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (todayArray.count > 0 && olderArray.count > 0) {
            return 2
        }
        else if (todayArray.count > 0 || olderArray.count > 0) {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let label = UILabel(frame: view.frame)
        if (section == 1) {
            label.text = "Earlier"
        }
        else {
            if (todayArray.count > 0) {
                label.text = "Today"
            }
            else {
                label.text = "Earlier"
            }
        }
        view.addSubview(label)
        label.textColor = UIColor.white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return olderArray.count
        }
        else {
            if (todayArray.count > 0) {
                return todayArray.count
            }
        }
        return olderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        var record: Record
        if (indexPath.section == 1) {
            record = olderArray[indexPath.row]
        }
        else {
            if (todayArray.count > 0) {
                record = todayArray[indexPath.row]
            }
            else {
                record = olderArray[indexPath.row]
            }
        }
        
        cell.name.text = record.fileName
        cell.time.text = durationFor(ticks: record.length!.intValue)
        if (record.submitted!.isEqual(to: NSNumber(value: 1))) {
            cell.status.text = "Submitted"
        }
        else {
            cell.status.text = "Not Submitted"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        cell.date.text = dateFormatter.string(from: record.date!)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editViewController = storyboard!.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        if (indexPath.section == 1) {
            editViewController.record = olderArray[indexPath.row]
        }
        else {
            if (todayArray.count > 0) {
                editViewController.record = todayArray[indexPath.row]
            }
            else {
                editViewController.record = olderArray[indexPath.row]
            }
        }
        navigationController!.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let record: Record
            if (indexPath.section == 1) {
                record = olderArray[indexPath.row]
            }
            else {
                if (todayArray.count > 0) {
                    record = todayArray[indexPath.row]
                }
                else {
                    record = olderArray[indexPath.row]
                }
            }
            DirectoryManager.instance.deleteFileAtPath(folderName: KFolder, fileName: record.fileName!)
            deleteFromCoreDataWithName(name: record.fileName!)
            setBadge()
            reload()
        }
    }
    
    ////////////////////////////////
    
    func reload() {
        todayArray = getAllMediaData(date: KToday)
        olderArray = getAllMediaData(date: KOld)
        recordTableView.reloadData()
    }
    
    func getAllMediaData(date: String) -> [Record] {
        let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
        if (date == KToday) {
            fetchRequest.predicate = NSPredicate(format: "date >= %@", calculateDate() as CVarArg)
        }
        if (date == KOld) {
            fetchRequest.predicate = NSPredicate(format: "date < %@", calculateDate() as CVarArg)
        }
        let sortDesciptor = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDesciptor]
        do {
            return try managedObjectContext!.fetch(fetchRequest) as [Record]
        }
        catch {
            return []
        }
    }
    
    func calculateDate() -> Date {
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -1
        return calendar.date(byAdding: dateComponents, to: now)!
    }
    
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
                tabBarController!.tabBar.items![1].badgeValue = ""
            }
        }
        catch {
            
        }
    }
    
    func durationFor(ticks: Int) -> String {
        let seconds = ticks % 60
        let minutes = ticks / 60
        
        var secondsStr = String(seconds)
        if (seconds < 10) {
            secondsStr = "0" + secondsStr
        }
        
        var minutesStr = String(minutes)
        if (minutes < 10) {
            minutesStr = "0" + minutesStr
        }
        
        return minutesStr + ":" + secondsStr
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
