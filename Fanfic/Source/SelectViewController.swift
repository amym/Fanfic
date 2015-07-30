//
//  SelectViewController.swift
//  Fanfic
//
//  Created by robert on 01/07/15.
//  Copyright (c) 2015 amymartin. All rights reserved.
//

import UIKit
import Parse

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}


class SelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    var CellIdentifier = "cellIdentifier"
    var filename = "starName-1.0"
    var btnNames:CSV!
    var selectedNames:NSMutableArray!
    var space_count=0
    var temp_num=0
    var storylist:NSMutableArray!
    
    @IBOutlet weak var co: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var progressBar: M13ProgressViewStripedBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBarHidden = true;
        var escapedString = filename.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        // Returning the String value
        
        if let path = NSBundle.mainBundle().pathForResource(escapedString, ofType:"csv") {
            var error: NSErrorPointer = nil
            btnNames = CSV(contentsOfFile: path, error: error)!
        }
        
        progressBar.cornerType = M13ProgressViewStripedBarCornerTypeSquare
        
    }
    
    func refreshNames() {
        var ok_res = false
        var width_size = CGFloat.min
        if DeviceType.IS_IPHONE_6P {
            width_size = self.view.frame.size.width - 150;
        }
        else {
            width_size = self.view.frame.size.width - 150;
        }
        var i = 0
        var j = 0
        var z = 0
        do {
            var lbl1 = UILabel(frame: CGRectMake(0, 0, 300, 20))
            if DeviceType.IS_IPHONE_6P {
                lbl1.font = UIFont.systemFontOfSize(18)
            }
            else {
                lbl1.font = UIFont.systemFontOfSize(11)
            }
            lbl1.text = btnNames.rows[i]["Name"]
            var sizetext1 = lbl1.sizeThatFits(CGSizeMake(CGFloat.max, 20))
            
            j = i+1
            do {
                var lbl2 = UILabel(frame: CGRectMake(0, 0, 300, 20))
                if DeviceType.IS_IPHONE_6P {
                    lbl2.font = UIFont.systemFontOfSize(18)
                }
                else if DeviceType.IS_IPHONE_6 {}
                else {
                    lbl2.font = UIFont.systemFontOfSize(11)
                }
                lbl2.text = btnNames.rows[j]["Name"]
                var sizetext2 = lbl2.sizeThatFits(CGSizeMake(CGFloat.max, 20))
                z = j+1
                do {
                    var lbl3 = UILabel(frame: CGRectMake(0, 0, 300, 20))
                    if DeviceType.IS_IPHONE_6P {
                        lbl3.font = UIFont.systemFontOfSize(18)
                    }
                    else if DeviceType.IS_IPHONE_6 {}
                    else {
                        lbl3.font = UIFont.systemFontOfSize(11)
                    }
                    lbl3.text = btnNames.rows[z]["Name"]
                    var sizetext3 = lbl3.sizeThatFits(CGSizeMake(CGFloat.max, 20))
                    var dis = CGFloat.min
                    if DeviceType.IS_IPHONE_6P {
                        dis = 70;
                    }
                    if DeviceType.IS_IPHONE_6 {
                        dis = 70;
                    }
                    else  {
                        dis = 50;
                    }
                    if (sizetext1.width + sizetext2.width + sizetext3.width) > width_size && (sizetext1.width + sizetext2.width + sizetext3.width) < (self.view.frame.size.width - dis) {
                        ok_res = true
                        
                        break
                    }
                    z = z+1
        
                }while (z < btnNames.rows.count)
                
                if ok_res {
                    break
                }
                j = j+1
                
            }while(j < btnNames.rows.count - 1)
            
            if ok_res {
                var tmp = btnNames.rows[i+1]["Name"]
                btnNames.rows[i+1]["Name"] = btnNames.rows[j]["Name"]
                btnNames.rows[j]["Name"] = tmp
                
                tmp = btnNames.rows[i+2]["Name"]
                btnNames.rows[i+2]["Name"] = btnNames.rows[z]["Name"]
                btnNames.rows[z]["Name"] = tmp
                
            }
            else {
                if i == temp_num {
                    space_count = space_count + 1
                }
                else {
                    space_count = 0
                }
                
                var tmp = btnNames.rows[i]["Name"]
                var p = i
                do{
                    btnNames.rows[p]["Name"] = btnNames.rows[p+1]["Name"]
                    p = p+1
                }while (p < btnNames.rows.count-1)
                btnNames.rows[p]["Name"] = tmp
                temp_num = i
                
                if space_count == (btnNames.rows.count - i) {
                    break
                }
                else {
                    continue
                }
            }
            
            i = i+3
        
            ok_res = false
        } while(i < btnNames.rows.count-2)
        selectedNames = NSMutableArray()
        for i=0;i<btnNames.rows.count;i++ {
            var integer_bool = "" as NSString;
            selectedNames.addObject(integer_bool)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.refreshNames()
        self.co.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if btnNames.rows.count % 3 == 0 {
            return btnNames.rows.count/3
        }
        else {
            return btnNames.rows.count/3+1
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func removeNaughtyLingeringCells() {
        var visibleCells = self.co.visibleCells()
        
        var visibleRect:CGRect = CGRect()
        visibleRect.origin = self.co.contentOffset
        visibleRect.size = self.co.bounds.size
        
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if DeviceType.IS_IPHONE_6P {
                return CGSizeMake(self.co.frame.size.width, 40)
            }
            else {
                return CGSizeMake(self.co.frame.size.width, 30)
            }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var otherCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
//        otherCell.frame = CGRectMake(0, otherCell.frame.origin.y, self.co.frame.size.width, otherCell.frame.size.height)
        
        for subView in otherCell.subviews {
            subView.removeFromSuperview()
        }
            var idx = 0
        if indexPath.row < temp_num - 1 {
            idx = indexPath.row * 3;
        }
        else  {
            idx = indexPath.row * 2;
        }
            var btn1:SSBouncyButton = SSBouncyButton()
            var btn2:SSBouncyButton = SSBouncyButton()
            var btn3:SSBouncyButton = SSBouncyButton()
            var textsize1:CGSize = CGSize()
        var textsize2:CGSize = CGSize()
        var textsize3:CGSize = CGSize()
        
            if idx < btnNames.rows.count {
                var sample_lbl1 = UILabel(frame: CGRectMake(0, 0, 300, 20));
                if DeviceType.IS_IPHONE_6P {
                    sample_lbl1.font = UIFont.systemFontOfSize(18)
                }
                else if DeviceType.IS_IPHONE_6 {}
                else {
                    sample_lbl1.font = UIFont.systemFontOfSize(11)
                }
                sample_lbl1.text = btnNames.rows[idx]["Name"];
                textsize1 = sample_lbl1.sizeThatFits(CGSizeMake(CGFloat.max, 20));
                btn1 = SSBouncyButton(frame: CGRectMake(0, 0, textsize1.width, otherCell.frame.size.height))
//                btn1.backgroundColor = UIColor.blueColor()
//                btn1.tintColor = UIColor.grayColor()
                btn1.tintColor = UIColor(red: 222/255, green: 142/255, blue: 172/255, alpha: 1)
                btn1.cornerRadius = 10;
                btn1.setTitle(btnNames.rows[idx]["Name"], forState: UIControlState.Normal)
                btn1.setTitle(btnNames.rows[idx]["Name"], forState: UIControlState.Selected)
                btn1.addTarget(self, action: "buttonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
                otherCell.addSubview(btn1)
                btn1.tag = idx;
                var i = selectedNames.objectAtIndex(idx) as! NSString
                if i.isEqualToString(""){
                    btn1.selected = false
                }
                else {
                    btn1.selected = true
                }
            }
            
            if (idx+1) < btnNames.rows.count {
                var sample_lbl2 = UILabel(frame: CGRectMake(0, 0, 300, 20));
                if DeviceType.IS_IPHONE_6P {
                    sample_lbl2.font = UIFont.systemFontOfSize(18)
                }
                else if DeviceType.IS_IPHONE_6 {}
                else {
                    sample_lbl2.font = UIFont.systemFontOfSize(11)
                }
                sample_lbl2.text = btnNames.rows[idx + 1]["Name"];
                textsize2 = sample_lbl2.sizeThatFits(CGSizeMake(CGFloat.max, 20));
                
                btn2 = SSBouncyButton(frame: CGRectMake(btn1.frame.size.width + 5, 0, textsize2.width, otherCell.frame.size.height))
//                btn2.tintColor = UIColor.grayColor()
                btn2.tintColor = UIColor(red: 222/255, green: 142/255, blue: 172/255, alpha: 1)
                btn2.setTitle(btnNames.rows[idx+1]["Name"], forState: UIControlState.Normal)
                btn2.setTitle(btnNames.rows[idx+1]["Name"], forState: UIControlState.Selected)
                btn2.cornerRadius = 10;
                btn2.addTarget(self, action: "buttonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
                otherCell.addSubview(btn2)
                btn2.tag = idx+1;
                var i = selectedNames.objectAtIndex(idx+1) as! NSString
                if i.isEqualToString("") {
                    btn2.selected = false
                }
                else {
                    btn2.selected = true
                }
            }
        
        
            if (idx+2) < btnNames.rows.count && (idx+1) < temp_num {
                var sample_lbl3 = UILabel(frame: CGRectMake(0, 0, 300, 20));
                if DeviceType.IS_IPHONE_6P {
                    sample_lbl3.font = UIFont.systemFontOfSize(18)
                }
                else if DeviceType.IS_IPHONE_6 {}
                else {
                    sample_lbl3.font = UIFont.systemFontOfSize(11)
                }
                sample_lbl3.text = btnNames.rows[idx + 2]["Name"];
                textsize3 = sample_lbl3.sizeThatFits(CGSizeMake(CGFloat.max, 20));
                btn3 = SSBouncyButton(frame: CGRectMake(btn2.frame.origin.x + btn2.frame.size.width + 5, 0, textsize3.width, otherCell.frame.size.height))
//                btn3.tintColor = UIColor.grayColor()
                btn3.tintColor = UIColor(red: 222/255, green: 142/255, blue: 172/255, alpha: 1)
                btn3.setTitle(btnNames.rows[idx+2]["Name"], forState: UIControlState.Normal)
                btn3.setTitle(btnNames.rows[idx+2]["Name"], forState: UIControlState.Selected)
                btn3.addTarget(self, action: "buttonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
                btn3.cornerRadius = 10;
                otherCell.addSubview(btn3)
                btn3.tag = idx+2
                var i = selectedNames.objectAtIndex(idx+2) as! NSString
                if i.isEqualToString("") {
                    btn3.selected = false
                }
                else {
                    btn3.selected = true
                }
                var add_size = CGFloat.min*0.0
                if (btn1.frame.size.width + btn2.frame.size.width + btn3.frame.size.width) < (self.co.frame.size.width - 10) {
                    add_size = (self.co.frame.size.width - (btn1.frame.size.width + btn2.frame.size.width + btn3.frame.size.width + 10)) / 3.0
                }
                
                btn1.frame = CGRectMake(0, btn1.frame.origin.y, btn1.frame.size.width + add_size, btn1.frame.size.height)
                btn2.frame = CGRectMake(btn1.frame.size.width + 5, btn2.frame.origin.y, btn2.frame.size.width + add_size, btn2.frame.size.height)
                btn3.frame = CGRectMake(btn1.frame.size.width + 5 + btn2.frame.size.width + 5, btn3.frame.origin.y, btn3.frame.size.width + add_size, btn3.frame.size.height)
            }
            else {
                btn1.frame = CGRectMake((self.co.frame.size.width - btn1.frame.size.width - btn2.frame.size.width - btn3.frame.size.width - 10)/2, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height)
                btn2.frame = CGRectMake((self.co.frame.size.width - btn1.frame.size.width - btn2.frame.size.width - btn3.frame.size.width - 10)/2 + btn1.frame.size.width + 5, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height)
            }
        
        if DeviceType.IS_IPHONE_6P {
            btn3.titleLabel?.font = UIFont.systemFontOfSize(15)
            btn2.titleLabel?.font = UIFont.systemFontOfSize(15)
            btn1.titleLabel?.font = UIFont.systemFontOfSize(15)
        }
        else {
            btn3.titleLabel?.font = UIFont.systemFontOfSize(9)
            btn2.titleLabel?.font = UIFont.systemFontOfSize(9)
            btn1.titleLabel?.font = UIFont.systemFontOfSize(9)
        }
        
        
        return otherCell
    }
    
    func buttonDidPress(button : UIButton) {
        
        button.selected = !button.selected;
        let tag_num = button.tag
        if button.selected {
            var i = "1" as NSString;
            selectedNames.replaceObjectAtIndex(button.tag, withObject: i)
        }
        else {
            var i = "" as NSString;
            selectedNames.replaceObjectAtIndex(button.tag, withObject: i)
        }
        
    }

    @IBAction func onClick_Done(sender: AnyObject) {
        loadingView.hidden = false
        
        var param = ""
        if self.storylist == nil {
            self.storylist = NSMutableArray()
        }
        else {
            self.storylist.removeAllObjects()
        }
        var i=0
        do {
            let str = selectedNames.objectAtIndex(i) as! NSString
            if str.isEqualToString("1") {
                var name = btnNames.rows[i]["Name"]
                parseRegister(name!)
                name = "%23"+name!
                if param.isEmpty {
                    param = name!
                    
                }
                else {
                    var tmp = param + " And " + name!
                    param = tmp
                }
            }
        
            i = i+1
        } while (i < btnNames.rows.count)
        if param.isEmpty {
            loadingView.hidden = true
            return
        }
        param = param.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var url = "https://api.wattpad.com:443/v4/stories?query="+param
        self.loadData(url)
        
    }
    
    func parseRegister(name:String) {
        var gameScore = PFObject(className:"NameList")
        gameScore["name"] = name
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                NSLog("success parse")
            } else {
                // There was a problem, check error.description
                NSLog("fail parse")
            }
        }

    }
    
    func loadData(url:String) {
        
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.requestSerializer.setValue("COmAsfoTl5bHFOoHoKl8uQCo12cA8sl2ytzk2RPu3uRB", forHTTPHeaderField: "Authorization")
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                let response = responseObject as! NSDictionary
                if let stories = responseObject?.objectForKey("stories") as? NSArray {
                    if stories.count == 0 {
                        self.loadingView.hidden = true
                        return
                    }
                    var total = responseObject.objectForKey("total") as! NSInteger
                    if total > 200 {
                        total = 200;
                    }
                    var idx=0
                    do {
                        let story = stories.objectAtIndex(idx) as? NSDictionary
                        let item = Story()
                        item.id = story?.objectForKey("id") as! NSInteger
                        item.title = story?.objectForKey("title") as! NSString
                        item.cover = story?.objectForKey("cover") as! NSString
                        item.desc = story?.objectForKey("description") as! NSString
                        item.tags = story?.objectForKey("tags") as! NSString
                        item.readCount = story?.objectForKey("readCount") as! NSInteger
                        self.storylist.addObject(item)
                        idx = idx + 1
                        
                        
                        var setProgress = Float(self.storylist.count) / Float(total)
                        self.progressBar.setProgress(CGFloat(setProgress), animated: true)
                        
                        NSLog("Total : %d, Stories Count : %d \n", total, self.storylist.count)
                        if total == self.storylist.count + 1 {
                            self.loadingView.hidden = true
                            self.performSegueWithIdentifier("gallery", sender: self)
                        }

                    
                    }while (idx < stories.count)
                    if let nexturl = responseObject.objectForKey("nextUrl") as? String {
                        self.loadData(nexturl)
                    }
                } else {
                    println("no quote")
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                
            }
        )

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gallery") {
            let vc = segue.destinationViewController as! GalleryViewController
            vc.storyList = self.storylist
        }
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
