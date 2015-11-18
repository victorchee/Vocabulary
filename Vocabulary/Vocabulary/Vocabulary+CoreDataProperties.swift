//
//  Vocabulary+CoreDataProperties.swift
//  Vocabulary
//
//  Created by qihaijun on 11/18/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vocabulary {

    @NSManaged var initial: String?
    @NSManaged var word: String?
    @NSManaged var wordID: String?
    @NSManaged var retention: NSDecimalNumber?
    @NSManaged var definition: String?
    @NSManaged var targetRetention: String?
    @NSManaged var learningID: String?
    @NSManaged var pronunciation: String?
    @NSManaged var audioUK: String?
    @NSManaged var audioUS: String?

}
