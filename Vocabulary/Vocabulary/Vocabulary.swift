//
//  Vocabulary.swift
//  Vocabulary
//
//  Created by qihaijun on 11/17/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit
import CoreData

class Vocabulary: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func add(word: String) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.managedObjectContext
        guard let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: context) as? Vocabulary else {
            return
        }
        newEntity.word = word
        if let initial = word.characters.first {
            newEntity.initial = String(initial).uppercaseString // 首字母全部大写
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("add word error \(nserror), \(nserror.userInfo)")
        }
    }
}
