//
//  ViewController.swift
//  AlertView
//
//  Created by harvey on 16/8/31.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button  = UIButton(frame:CGRectMake(100,100,100,30))
        button.setTitle("show alert", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action:#selector(showAlert), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        }

    func showAlert(){
    
        let alertView = YHAlertView(size:CGSizeMake(180,200),style:.FadeIn,title:"alertview")
        alertView.show()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

