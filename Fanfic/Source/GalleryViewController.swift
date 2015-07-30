//
//  GalleryViewController.swift
//  Fanfic
//
//  Created by robert on 04/07/15.
//  Copyright (c) 2015 amymartin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    var pageViewController : UIPageViewController?
    var storyList : NSMutableArray!
    
    
    var currentIndex=0
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let padding = view.frame.width/10.0
        let imageWidth = padding * 8.0
        let imageHeight = imageWidth/256.0 * 400.0

        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: InstructionView = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, (self.view.frame.height - padding - imageHeight)/2 - padding * 0.5, view.frame.size.width, imageHeight + padding*2);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        
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
    }
    
    func onClickBack(sender: AnyObject) {
        self.performSegueWithIdentifier("back", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "back") {
            let vc = segue.destinationViewController as! SelectViewController
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! InstructionView).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! InstructionView).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.storyList.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> InstructionView?
    {
        if self.storyList.count == 0 || index >= self.storyList.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = InstructionView()
        pageContentViewController.pageIndex = index
        pageContentViewController.story = self.storyList.objectAtIndex(index) as! Story
        currentIndex = index
        
        return pageContentViewController
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
