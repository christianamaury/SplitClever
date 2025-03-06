//
//  ThirdVController.swift
//  SplitClever
//
//  Created by Amaury C. Rivera on 1/23/24.
//

import UIKit

//App Reviews Purposes:
import StoreKit

//Importing GoogleMobile Ads Library;
import GoogleMobileAds

//UIImage View for the UI Background;
let mainBackgroundImage = UIImageView()

class ThirdVController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate
{
    //GoogleAds Banner Reference..
    @IBOutlet weak var banner: GADBannerView!
    //Interestial Ads, Google Ads
    var interstitial: GADInterstitial!
    
    //Variable for the Randomizer Class;
    var desiredRandomNumber: Int = 2
    
    //Data Reference from the ViewController;
    let dataReference = ViewController()
    
    //Product ID: "SplitCleverNoAds" - No Ads on the application.
    let productID: String = "SplitCleverNoAds"
    
    //Labels
    @IBOutlet weak var labelTabPerPerson: UILabel!
    @IBOutlet weak var labelTipPerPerson: UILabel!
    @IBOutlet weak var labelTotalPerPerson: UILabel!
    @IBOutlet weak var labelGrantTotal: UILabel!
    
    var tabPerPersonString: String = " "
    var tipPerPersonString: String = " "
    var totalPerPersonString: String = " "
    var grantTotalBillString: String = " "
 

    //Google Ads Test Units:
    //iOS Test Ads Unit: ca-app-pub-3940256099942544/2934735716
    //iOS Test Interestiads Ads: ca-app-pub-3940256099942544/4411468910
    
    // MARK: - Random Interestial Ads;
    func randomInterestialAds() {
        
        //Decided to permantently just the ads to the user;
        if(isPurchased()) {
          
            //Do not display any Ads. Remove All Interestial Ads.
            print("User already removed the Ads")
            
        }
        else{
            
        //Showing Interstial Ads to the user, User haven't removed all Ads;
        showInterstitial()
            
        }

    }
   
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
       banner.isHidden = false
        
        if(isPurchased())
        {
            banner.isHidden = true
            
        }
        else
        { 
            banner.isHidden = false
        }
       
    }
    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        banner.isHidden = true
        
        if(isPurchased())
        {
            banner.isHidden = true
        }
        
    }
    
    // If the application has been bought before;
     func isPurchased() -> Bool {
         let purchasesStatus = dataReference.userDefaultsReference.bool(forKey: productID)
        if purchasesStatus {
            
            //..Whether Shows Ads or Not;
            
            print("Previously Purchased")
            return true
        
        }
        
        else{
            print("Never Purchased")
            return false
        }
        
    }
    
    func showingBannerAds() {
        
        let removeAllAdsPurchase = dataReference.userDefaultsReference.bool(forKey: productID)

        if(removeAllAdsPurchase)
        {
            //If its true, remove all Ads
            banner.isHidden = true
        }
        else {
            
            banner.isHidden = false
        }
    }
    func removingAllAds(){
    
        dataReference.userDefaultsReference.set(true, forKey: productID)
    }
    
    //Create/Load another secondary interstial Ads after the 1st one has been displayed;
    func createAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-3187572158588519/9010186782")
        inter.load(GADRequest())
        return inter
    }
    
    //Showing Interestial Ads if there's one already available;
    func showInterstitial () {
        if(interstitial.isReady){
            interstitial.present(fromRootViewController: self)
            
            //Equal to create/load function below
            interstitial = createAd()
        }
    }
    
    //IBAction Button: Rate Us
    @IBAction func rateUsButton(_ sender: UIButton) 
    {
        //Since its an optional, lets unwrap it..
        guard let scene = view.window?.windowScene else{
            print("No scene available right at the moment..")
            return
        }
        
        //Requesting user to Rate Application..(Only would work on iOS 14)
        SKStoreReviewController.requestReview(in: scene)
    }
    
    
    //Split Another Bill: Back to the SecondVController;
    @IBAction func splitAnotherBillButton(_ sender: UIButton) 
    {
        //Showing Interestial Ads before taking him to the SecondVController;
        randomInterestialAds()
        
        //Identifier to the SecondView Controller: splitBill;
        //Performing Segue..
        performSegue(withIdentifier: "splitBill", sender: self)
    }

    //Setting actual UI background;
    func setMainbackground() {
        
        //Adding this specific View to the Parent View;
        view.addSubview(mainBackgroundImage)
        
        //Using No-AutoLayout
        mainBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        mainBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        mainBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //Loading UIImage;
        mainBackgroundImage.image = UIImage(named: "ThirdMainBackground")
        
        //Setting Image to Fill the Screen; Previously .scaleToFill
        mainBackgroundImage.contentMode = .scaleAspectFill
        view.sendSubviewToBack(mainBackgroundImage)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //..GoogleMobile Ads Initial State: Hidden if there's no Ads to the Show
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/8245251092"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
        
        //Requesting-Intertestial Ads:
        //Testing: ca-app-pub-3940256099942544/4411468910
        //Real: ca-app-pub-3187572158588519/9010186782
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3187572158588519/9010186782")
        let request = GADRequest()
        interstitial.load(request)
        
        //Calling function to the set the UI Background;
        setMainbackground()
        
        //..Assigning transferred string values to our labels.
        self.labelTabPerPerson.text = "$\(tabPerPersonString)"
        self.labelTipPerPerson.text = "$\(tipPerPersonString)"
        self.labelTotalPerPerson.text = "$\(totalPerPersonString)"
        self.labelGrantTotal.text = "$\(grantTotalBillString)"
        
        //Hiding Navigation Controller Back Arrow Button..;
        self.navigationItem.hidesBackButton = true
        
        //Check if the user previously bought the app;
        if isPurchased()
        {
            //Removing All Ads from the App;
            removingAllAds()
        }
        
        else
        {
            //Since the user has not bought it before, show all Ads;
            showingBannerAds()
        }
        
        //Creating a bar button item with the Title of the 3rd View Controller;
        let thirdVController = UIBarButtonItem(title: "Split Tabs", style: .plain, target: self, action: #selector(navigateFourthVController))
        
        //Adding the navigation bar to the top right corner.
        self.navigationItem.rightBarButtonItem = thirdVController
         
        
    }
    
    @objc func navigateFourthVController(){
        
        if let thirdVC = storyboard?.instantiateViewController(identifier:"FourthVController"){
            
            navigationController?.pushViewController(thirdVC, animated: true)
        }
        
    }
   

}
