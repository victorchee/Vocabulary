//
//  Vocabulary+CoreDataProperties.swift
//  Vocabulary
//
//  Created by qihaijun on 11/17/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vocabulary {

    @NSManaged var word: String?
    //! 首字母
    @NSManaged var initial: String?

}
