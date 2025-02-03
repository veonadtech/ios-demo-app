//
//  ViewController.swift
//  HelloWorld
//
//  Created by Enrico Rossini on 20/07/2021.
//

import UIKit
import GoogleMobileAds
import PrebidMobile
import PrebidMobileGAMEventHandlers

fileprivate let storedImpDisplayBanner = "mybl_android_slot4_commerce_home_320x50"
fileprivate let gamAdUnitDisplayBannerRendering = "/21808260008/prebid_oxb_320x50_banner"

class ViewController: UIViewController, BannerViewDelegate {
    var count = 0
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var btn1: UIButton!
    
    func bannerViewPresentationController() -> UIViewController? {
        self
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWith error: Error) {
        //PrebidDemoLogger.shared.error("Banner view did fail to receive ad with error: \(error)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl1.text = "Hello World!"
        
        let adSize = CGSize(width: 320, height: 50)
            
        // 1. Create a BannerView
        let prebidBannerView = BannerView(frame: CGRect(origin: .zero, size: adSize), configID: storedImpDisplayBanner, adSize: adSize)
        
        // 2. Configure the BannerView
        prebidBannerView.delegate = self
        prebidBannerView.adFormat = .banner
        //prebidBannerView.videoParameters.placement = .InBanner
        
        // Add Prebid banner view to the app UI
        view.backgroundColor = .clear
        view.addSubview(prebidBannerView)
        
        // 3. Load the banner ad
        prebidBannerView.loadAd()

        addBannerViewToView(prebidBannerView)
    }
    
    @IBAction func btn1Tapped(_ sender: Any) {
        count = count + 1
        lbl1.text = String(count)
    }
    
    func addBannerViewToView(_ bannerView: BannerView) {
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(bannerView)
       // This example doesn't give width or height constraints, as the provided
       // ad size gives the banner an intrinsic content size to size the view.
       view.addConstraints(
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: view.safeAreaLayoutGuide,
                             attribute: .bottom,
                             multiplier: 1,
                             constant: 0),
         NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
     }
    
}

