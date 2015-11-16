//
//  ViewController.swift
//  Vocabulary
//
//  Created by qihaijun on 11/10/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
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
            network.searchWord(word, callback: { (json) -> Void in
                if let json = json {
                    print(json)
                }
            })
        }
        return true
    }
}

