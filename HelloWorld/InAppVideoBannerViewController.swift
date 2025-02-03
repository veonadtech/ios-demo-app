import UIKit
import PrebidMobile

fileprivate let storedImpVideoBanner = "prebid-demo-video-outstream"

class InAppVideoBannerViewController: BannerBaseViewController, BannerViewDelegate {
    
    // Prebid
    private var prebidBannerView: BannerView!
    
    override func loadView() {
        super.loadView()
        createAd()
    }
    
    func createAd() {
        // 1. Create a BannerView
        prebidBannerView = BannerView(frame: CGRect(origin: .zero, size: adSize), configID: storedImpVideoBanner, adSize: adSize)
        
        // 2. Configure the BannerView
        prebidBannerView.delegate = self
        prebidBannerView.adFormat = .video
        prebidBannerView.videoParameters.placement = .InBanner
        
        // Add Prebid banner view to the app UI
        bannerView.backgroundColor = .clear
        bannerView.addSubview(prebidBannerView)
        
        // 3. Load the banner ad
        prebidBannerView.loadAd()
    }
    
    
    // MARK: - BannerViewDelegate
    
    func bannerViewPresentationController() -> UIViewController? {
        self
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWith error: Error) {
        PrebidDemoLogger.shared.error("Banner view did fail to receive ad with error: \(error)")
    }
}
