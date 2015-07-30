//
//  InstructionView.swift
//  Listing Pro
//
//  Created by robert on 26/05/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit

class InstructionView: UIViewController {

    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    var story:Story!
    var imageView : UIImageView!
    var readCountView : UIView!
    var paddingView : UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let padding = view.frame.width/10.0
        let imageWidth = padding * 8.0
        let imageHeight = imageWidth/256.0 * 400.0
        let margin = 15;
        
        paddingView = UIView(frame: CGRectMake(padding, 0, imageWidth, imageHeight + padding * 2))
        paddingView.layer.cornerRadius = 5
        paddingView.backgroundColor = UIColor(red: 187/255.0, green: 148/255.0, blue: 162/255.0, alpha: 1.0)
        
        self.view.addSubview(paddingView)
        imageView = UIImageView(frame: CGRectMake(CGFloat(margin), CGFloat(margin), imageWidth - CGFloat(margin)*2, imageHeight - CGFloat(margin)))

        if story != nil {
            imageView.setImageWithURL(NSURL(string: story.cover as! String))
        }

        readCountView = UIView(frame: CGRectMake(CGFloat(margin), imageView.frame.origin.y+imageView.frame.size.height, imageWidth-CGFloat(margin)*2, padding * 2.0-CGFloat(margin)))
        readCountView.backgroundColor = UIColor(red: 116/255.0, green: 195/255.0, blue: 218/255.0, alpha: 0.99)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        
        let hardImage = UIImageView(frame: CGRectMake(0, 0, padding-5, padding-5))
        hardImage.image = UIImage(named: "hard")
        let readCountLabel = UILabel(frame: CGRectMake(0, 0, readCountView.frame.size.width, padding))
        readCountLabel.font = UIFont.systemFontOfSize(30.0)
        readCountLabel.text = String(story.readCount)
        readCountLabel.textColor = UIColor.whiteColor()
        readCountLabel.font = UIFont.boldSystemFontOfSize(30.0)
        let labelSize = readCountLabel.sizeThatFits(CGSizeMake(readCountLabel.frame.size.width, readCountLabel.frame.size.height))
        let x = (readCountView.frame.size.width - hardImage.frame.size.width - labelSize.width - 20.0)/2.0
        let y = (readCountView.frame.size.height - hardImage.frame.size.height)/2.0
        
        hardImage.frame = CGRectMake(x, y, hardImage.frame.size.width, hardImage.frame.size.height)
        readCountLabel.frame = CGRectMake(x + hardImage.frame.size.width + 20.0, y, labelSize.width, hardImage.frame.size.height)
        hardImage.contentMode = UIViewContentMode.ScaleAspectFit
        readCountView.addSubview(hardImage)
        readCountView.addSubview(readCountLabel)
        
        let btnImage = UIButton(frame: CGRectMake(padding, (view.frame.height - padding - imageHeight)/2, imageWidth, imageHeight))
        btnImage.backgroundColor = UIColor.clearColor()
        btnImage.addTarget(self, action: "onClickImage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnImage)
        
        paddingView.addSubview(imageView)
        paddingView.addSubview(readCountView)
        
    }
    
    
    func onClickImage(sender: AnyObject) {
        let InfoVC = DetailViewController()
        InfoVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        InfoVC.story = story
        InfoVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        readCountView.hidden = true
        imageView.hidden = true
        paddingView.hidden = true
        
        self.presentViewController(InfoVC, animated: true, completion: {
            self.readCountView.hidden = false
            self.imageView.hidden = false
            self.paddingView.hidden = false
        });
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
