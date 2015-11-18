//
//  ViewController.swift
//  Vocabulary
//
//  Created by qihaijun on 11/10/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    let network = NetworkInterface()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let word = textField.text {
            // trimming
            let fixedWord = word.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if fixedWord.characters.count > 0 {
                network.searchWord(fixedWord, callback: { (json) -> Void in
                    if let json = json {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            textField.resignFirstResponder()
                        })
                        guard let result = json as? [String : AnyObject] else {
                            return
                        }
                        guard let statusCode = result["status_code"] as? NSNumber else {
                            return
                        }
                        if statusCode.integerValue == 0 {
                            guard let data = result["data"] as? [String : AnyObject] else {
                                return
                            }
                            Vocabulary.add(data)
                        }
                    }
                })
            }
        }
        
        return true
    }
}

