//
//  WebViewController.swift
//  Fanfic
//
//  Created by robert on 05/07/15.
//  Copyright (c) 2015 amymartin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var story:Story!
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        let url = "http://www.wattpad.com/story/" + String(story.id)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        self.view.addSubview(webView)
        let imageBtn = UIImageView(frame: CGRectMake(60, 60, 30, 30))
        imageBtn.image = UIImage(named: "backbtn")
        imageBtn.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageBtn)
        
        let backButton = UIButton(frame: CGRectMake(50, 50, 50, 50))
        backButton.backgroundColor = UIColor(red: 116/255.0, green: 195/255.0, blue: 218/255.0, alpha: 0.5)
        
        backButton.addTarget(self, action: "onClickBack:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.layer.cornerRadius = 25;
        self.view.addSubview(backButton)
        // Do any additional setup after loading the view.
    }
    
    func onClickBack(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
