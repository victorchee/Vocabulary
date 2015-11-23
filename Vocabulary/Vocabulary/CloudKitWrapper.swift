//
//  CloudKitWrapper.swift
//  Vocabulary
//
//  Created by qihaijun on 11/23/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit
import CloudKit

/*
CKContainer: Containers 就像应用运行的沙盒一样，一个应用只能访问自己沙盒中的内容而不能访问其他应用的。Containers 就是最外层容器，每个应用有且仅有一个属于自己的 container。（事实上，经过开发者授权配置 CloudKit Dashboard 之后，一个应用也可以访问其他应用的 container。）

CKDatabase: Database 即数据库，私有数据库用来存储敏感信息，比如说用户的性别年龄等，用户只能访问自己的私有数据库。应用也有一个公开的数据库来存储公共信息，例如你在构建一个根据地理位置签到的应用，那么地理位置信息就应该存储在公共数据库里以便所有用户都能访问到。

CKRecord: 即数据库中的一条数据记录。CloudKit 使用 record 通过 k/v 结构来存储结构化数据。关于键值存储，目前值的架构支持 NSString、NSNumber、NSData、NSDate、CLLocation，和 CKReference、CKAsset（这两个下面我们会说明），以及存储以上数据类型的数组。

CKRecordZone: Record 不是以零散的方式存在于 database 之中的，它们位于 record zones 里。每个应用都有一个 default record zone，你也可以有自定义的 record zone。

CKRecordIdentifier: 是一条 record 的唯一标识，用于确定该 record 在数据库中的唯一位置。

CKReference: Reference 很像 RDBMS 中的引用关系。还是以地理位置签到应用为例，每个地理位置可以包含很多用户在该位置的签到，那么位置与签到之间就形成了这样一种包含式的从属关系。

CKAsset: 即资源文件，例如二进制文件。还是以签到应用为例，用户签到时可能还包含一张照片，那么这张照片就会以 asset 形式存储起来。
*/

class CloudKitWrapper: NSObject {
    static let sharedWrapper = CloudKitWrapper()
    
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    let privateDB = CKContainer.defaultContainer().privateCloudDatabase
    
//    一个更好的解决办法是，使用 NSOperation 的依赖来管理互相依赖的任务：
//    let firstFetch = CKFetchRecordsOperation()
//    let secondFetch = CKFetchRecordsOperation()
//    secondFetch.addDependency(firstFetch)
//    let queue = NSOperationQueue()
//    queue.addOperations([firstFetch, secondFetch], waitUntilFinished: false)
    
    func checkPermission() {
        CKContainer.defaultContainer().statusForApplicationPermission(CKApplicationPermissions.UserDiscoverability) { (permissionStatus, error) -> Void in
            switch permissionStatus {
            case .InitialState:
                CKContainer.defaultContainer().requestApplicationPermission(.UserDiscoverability, completionHandler: { (permissionStatus, error) -> Void in
                    print(permissionStatus)
                })
            case .CouldNotComplete:
                print(error)
            case .Denied:
                print("Denied")
            case .Granted:
                print("Granted")
            }
        }
    }
    
    func insertWord(word: Vocabulary) {
        guard let wordID = word.wordID else {
            return
        }
        let recordID = CKRecordID(recordName: wordID)
        let record = CKRecord(recordType: "Word", recordID: recordID)
        record["initial"] = word.initial
        record["word"] = word.word
        record["retention"] = word.retention
        record["definition"] = word.definition
        record["targetRetention"] = word.targetRetention
        record["learningID"] = word.learningID
        record["pronunciation"] = word.pronunciation
        record["audioUK"] = word.audioUK
        record["audioUS"] = word.audioUS
        
        saveRecord(record)
    }
    
    func fetchWord(wordID: String, completionHandler: (CKRecord?, NSError?) -> Void) {
        let recordID = CKRecordID(recordName: wordID)
        publicDB.fetchRecordWithID(recordID) { (record, error) -> Void in
            completionHandler(record, error)
        }
    }
    
    func updateWord(word: Vocabulary) {
        guard let wordID = word.wordID else {
            return
        }
        fetchWord(wordID)  { (record, error) -> Void in
            guard let fetchedRecord = record else {
                // handle errors
                print(error)
                return
            }
            
            // update
            fetchedRecord["initial"] = word.initial
            fetchedRecord["word"] = word.word
            fetchedRecord["retention"] = word.retention
            fetchedRecord["definition"] = word.definition
            fetchedRecord["targetRetention"] = word.targetRetention
            fetchedRecord["learningID"] = word.learningID
            fetchedRecord["pronunciation"] = word.pronunciation
            fetchedRecord["audioUK"] = word.audioUK
            fetchedRecord["audioUS"] = word.audioUS
            
            // save
            self.saveRecord(fetchedRecord)
        }
    }
    
    func deleteWord(wordID: String) {
        let recordID = CKRecordID(recordName: wordID)
        publicDB.deleteRecordWithID(recordID) { (record, error) -> Void in
            if let error = error {
                print(error)
            } else {
                print(record)
            }
        }
    }
    
    func saveRecord(record: CKRecord) {
        publicDB.saveRecord(record) { (record, error) -> Void in
            if let error = error {
                if let retryAfterValue = error.userInfo[CKErrorRetryAfterKey] as? NSTimeInterval {
                    let retryAfterDate = NSDate(timeIntervalSinceNow: retryAfterValue)
                    print(retryAfterDate)
                }
            } else {
                print(record)
            }
        }
    }
}
