//
//  Record.swift
//  eword
//
//  Created by Admin on 24/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import CoreData

class Record : NSManagedObject {
    dynamic var type: String?
    dynamic var date: Date?
    dynamic var submitted: NSNumber?
    dynamic var length: NSNumber?
    dynamic var fileName: String?
}
