//
//  DetailViewController.swift
//  Fanfic
//
//  Created by robert on 04/07/15.
//  Copyright (c) 2015 amymartin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var story:Story!
    override func viewDidLoad() {
        super.viewDidLoad()

        let padding = view.frame.width/10.0
        let imageWidth = padding * 8.0
        let imageHeight = imageWidth/256.0 * 400.0
        
//        let paddingView = UIView(frame: CGRectMake(padding, 0, imageWidth, imageHeight + padding * 2))
//        paddingView.layer.cornerRadius = 5
//        paddingView.backgroundColor = UIColor(red: 187/255.0, green: 148/255.0, blue: 162/255.0, alpha: 1.0)
//        
//        self.view.addSubview(paddingView)

        let background = UIImageView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        background.image = UIImage(named: "back")
//        view.addSubview(background)
        self.view.backgroundColor = UIColor.clearColor()
        
        let imageView = UIImageView(frame: CGRectMake(padding, (view.frame.height - padding - imageHeight)/2 - padding*0.5, imageWidth, imageHeight))
        
        if story != nil {
            imageView.setImageWithURL(NSURL(string: story.cover as! String))
        }
        
        let readCountView = UIView(frame: CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+imageHeight, imageWidth, padding*2))
        readCountView.backgroundColor = UIColor.blackColor()
        let readImage = UIImageView(frame: CGRectMake(0, 0, imageWidth, padding*2))
        readImage.image = UIImage(named: "read_black")
        readCountView.addSubview(readImage)
        
        let readBtn = UIButton(frame: CGRectMake(0, 0, imageWidth, padding*2))
        readBtn.addTarget(self, action: "onClickReadBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        readCountView.addSubview(readBtn)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.view.addSubview(imageView)
        self.view.addSubview(readCountView)
        
      
        
        let blurView = UIView(frame: CGRectMake(padding, (view.frame.height - padding - imageHeight)/2 - padding * 0.5, imageWidth, imageHeight))
        blurView.backgroundColor = UIColor(red: 116/255.0, green: 195/255.0, blue: 218/255.0, alpha: 0.8)
        self.view.addSubview(blurView)

        let backBtn : UIButton
        if (self.view.frame.size.height - imageHeight - 2 * padding) / 2 < padding * 1.5 {
            backBtn = UIButton(frame: CGRectMake(padding/4, self.view.frame.height - padding * 1.5, padding/2.0, padding))
        }
        else {
            backBtn = UIButton(frame: CGRectMake(padding, self.view.frame.height - ((self.view.frame.height - imageHeight - padding * 2)/2 - padding)/2 - padding, padding/2.0, padding))
        }

        backBtn.setImage(UIImage(named: "backbtn"), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "onClickBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.view.addSubview(backBtn)
        
        let scrollview = UIScrollView(frame: CGRectMake(padding, (view.frame.height - padding - imageHeight)/2 - padding*0.5, imageWidth, imageHeight))
        scrollview.backgroundColor = UIColor.clearColor()
        
        let title = UILabel(frame: CGRectMake(10, 10, imageWidth-20, 50.0))
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.text = String(story.title)
        title.font = UIFont.boldSystemFontOfSize(25.0)
        let titleSize = title.sizeThatFits(CGSizeMake(title.frame.size.width, CGFloat.max))
        title.frame = CGRectMake((scrollview.frame.size.width-titleSize.width)/2.0, 30, titleSize.width, titleSize.height)

        let desc = UILabel(frame: CGRectMake(10, 0, imageWidth-20, 50.0))
        desc.text = String(story.desc)
        desc.numberOfLines = 0
        desc.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let descSize = desc.sizeThatFits(CGSizeMake(desc.frame.size.width, CGFloat.max))
        desc.frame = CGRectMake((scrollview.frame.size.width - descSize.width)/2, title.frame.origin.y + title.frame.size.height + 20, descSize.width, descSize.height)
        
        
        
        let mainView = UIView(frame: CGRectMake(0, 0, scrollview.frame.size.width, desc.frame.origin.y + desc.frame.size.height + 20))
        
        let tag = story.tags as String
        let tagArr = split(tag) {$0 == " "}
        
        var y = mainView.frame.size.height + 10.0
        var x : CGFloat = 10.0
        for var i=0;i<tagArr.count;i=i+1 {
            let lbl = UILabel(frame: CGRectMake(CGFloat(x), CGFloat(y), CGFloat.max, CGFloat.max))
            lbl.text = tagArr[i]
            let size = lbl.sizeThatFits(CGSizeMake(CGFloat.max, 20.0))
            if CGFloat(x) + size.width > mainView.frame.size.width - 20 {
                x = 10.0
                y = y + 25
            }
            lbl.frame = CGRectMake(CGFloat(x), CGFloat(y), size.width+5, size.height)
            lbl.textAlignment = NSTextAlignment.Center
            lbl.layer.borderWidth = 1
            lbl.layer.borderColor = UIColor.grayColor().CGColor
            lbl.layer.cornerRadius = 10
            lbl.textColor = UIColor.whiteColor()
            lbl.font = UIFont.systemFontOfSize(10)
            x = x + size.width + 10
            mainView.addSubview(lbl)
        }
        mainView.frame = CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, mainView.frame.size.width, CGFloat(y+30))
        mainView.addSubview(title)
        mainView.addSubview(desc)
        
        scrollview.addSubview(mainView)
        scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, mainView.frame.size.height)
        scrollview.scrollEnabled = true
        self.view.addSubview(scrollview)
        
        title.textColor = UIColor.whiteColor()
        desc.textColor = UIColor.whiteColor()
        title.font = UIFont.boldSystemFontOfSize(25.0)
        // Do any additional setup after loading the view.
    }
    
    func onClickReadBtn(sender: AnyObject) {
        let vc = WebViewController()
        vc.story = story
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func onClickBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
