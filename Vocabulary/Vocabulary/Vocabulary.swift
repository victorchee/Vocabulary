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
    class func add(wordInfo: [String : AnyObject]) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.managedObjectContext
        guard let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: context) as? Vocabulary else {
            return
        }
        
        if let word = wordInfo["content"] as? String {
            newEntity.word = word
            
            if let initial = word.characters.first {
                newEntity.initial = String(initial).uppercaseString // 首字母全部大写
            }
        }
        
        if let wordID = wordInfo["content_id"] as? NSNumber {
            newEntity.wordID = wordID.stringValue
        }
        
        if let definition = wordInfo["definition"] as? String {
            newEntity.definition = definition
        }
        
        if let pronunciation = wordInfo["pronunciation"] as? String {
            newEntity.pronunciation = pronunciation
        }
        
        if let audioUK = wordInfo["uk_audio"] as? String {
            newEntity.audioUK = audioUK
        }
        
        if let audioUS = wordInfo["us_audio"] as? String {
            newEntity.audioUS = audioUS
        }
        
        do {
            try context.save()
            
            CloudKitWrapper.sharedWrapper.insertWord(newEntity)
        } catch {
            let nserror = error as NSError
            NSLog("add word error \(nserror), \(nserror.userInfo)")
        }
    }
}
