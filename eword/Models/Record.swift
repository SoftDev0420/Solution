//
//  Record.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import CoreData

class Record : NSManagedObject {
    @NSManaged var type: String?
    @NSManaged var date: Date?
    @NSManaged var submitted: NSNumber?
    @NSManaged var length: NSNumber?
    @NSManaged var fileName: String?
}
