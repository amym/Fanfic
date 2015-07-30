//
//  FacebookAdViewController.swift
//  Fanfic
//
//  Created by robert on 08/07/15.
//  Copyright (c) 2015 amymartin. All rights reserved.
//

import UIKit
import FBAudienceNetwork

class FacebookAdViewController: UIViewController, FBNativeAdDelegate {
    
    var nativeAdView:UIView!
    override func viewDidLoad()
    {
        let padding = view.frame.width/8.0
        let imageWidth = padding * 6.0
        let imageHeight = imageWidth/256.0 * 400.0
        self.view.backgroundColor = UIColor.clearColor()
        
        nativeAdView = UIView(frame: CGRectMake(padding, (view.frame.height - padding - imageHeight)/2 - padding*0.5, imageWidth, imageHeight + padding*1.5))
        showNativeAd()
    }
    
    func showNativeAd() {
        let nativeAd = FBNativeAd(placementID: "")
        nativeAd.delegate = self
        nativeAd .loadAd()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func nativeAdDidLoad(nativeAd: FBNativeAd!) {
        
        let titleForAd = nativeAd.title
        let bodyTextForAd = nativeAd.body
        let coverImage = nativeAd.coverImage
        let iconForAd = nativeAd.icon
        let socialContextForAd = nativeAd.socialContext
        let appRatingForAd = nativeAd.starRating
        let titleForAdButton = nativeAd.callToAction
        
        let adIcon = UIImageView(frame: CGRectMake(5, 5, 25, 30))
        adIcon.setImageWithURL(iconForAd.url)
        
        let adTitle = UILabel(frame: CGRectMake(adIcon.frame.origin.x + 5, 10, nativeAdView.frame.size.width - 10 - adIcon.frame.size.width, 30))
        adTitle.font = UIFont.boldSystemFontOfSize(13)
        adTitle.text = titleForAd
        adTitle.numberOfLines = 1
        
//        let titleSize = adTitle.sizeThatFits(CGSizeMake(adTitle.frame.size.width, CGFloat.max))
//        adTitle.frame = CGRectMake(adIcon.frame.origin.x + 5, 10, titleSize.width, titleSize.height)
        
        let bodytitle = UILabel(frame: CGRectMake(5, adIcon.frame.size.height + 15, nativeAdView.frame.size.width - 10, 60))
        bodytitle.text = bodyTextForAd
        bodytitle.font = UIFont.systemFontOfSize(12)
        bodytitle.numberOfLines = 2
//        let bodySize = bodytitle.sizeThatFits(CGSizeMake(bodytitle.frame.size.width, CGFloat.max))
//        bodytitle.frame = CGRectMake(5, adIcon.frame.size.height + 15, bodySize.width, bodySize.height)

        let AdCoverImage = UIImageView(frame: CGRectMake(0, bodytitle.frame.origin.y + bodytitle.frame.size.height + 5, nativeAdView.frame.size.width, nativeAdView.frame.size.height/2))
        AdCoverImage.setImageWithURL(coverImage.url)
        
        let actionBtn = UIButton()
        actionBtn.backgroundColor = UIColor.greenColor()
        actionBtn.layer.cornerRadius = 3;
        let lbl = UILabel()
        lbl.text = titleForAdButton
        let btnTitlesize = lbl.sizeThatFits(CGSizeMake(CGFloat.max, 20))
        actionBtn.frame = CGRectMake(nativeAdView.frame.size.width - btnTitlesize.width - 20, nativeAdView.frame.size.height - 50, btnTitlesize.width + 10, 35)
        actionBtn.titleLabel?.text = titleForAdButton
        
        nativeAdView.addSubview(adIcon)
        nativeAdView.addSubview(adTitle)
        nativeAdView.addSubview(bodytitle)
        nativeAdView.addSubview(AdCoverImage)
        nativeAdView.addSubview(actionBtn)
        
        self.view.addSubview(nativeAdView)
        
        // Register the native ad view and its view controller with the native ad instance
        nativeAd .registerViewForInteraction(nativeAdView, withViewController: self)

    }
}
