//
//  ViewController.swift
//  SplitClever
//
//  Created by Amaury C. Rivera on 1/23/24.
//

import UIKit
//StoreKit Library for the Purchases Events;
import StoreKit
//Library for UserNotifications purposes;
import UserNotifications

//Importing GoogleMobile Ads Library
import GoogleMobileAds

class ViewController: UIViewController, SKPaymentTransactionObserver, GADBannerViewDelegate, GADInterstitialDelegate {
    
    //Product ID: "SplitCleverNoAds" - No Ads on the application.
    let productID: String = "SplitCleverNoAds"
    
    //Saving Data; Purchases;
    public let userDefaultsReference = UserDefaults()
    
    //UIImage View for the background;
    let mainBackgroundImage = UIImageView()
    
    @IBOutlet weak var banner: GADBannerView!
    
    //Google Ads Test Units:
    //iOS Test Ads Unit: ca-app-pub-3940256099942544/2934735716
    //iOS Test Interestiads Ads: ca-app-pub-3940256099942544/4411468910
    //iOS Banner Ads: ca-app-pub-3187572158588519/8245251092
    
    var testingBool: Bool = false
    
    //Remove Ads Button & Restore Purchases Label;
    @IBOutlet weak var removeAdsLabel: UIButton!
    @IBOutlet weak var restorePurchasesLabel: UIButton!
    
    //..Checking if a Purchase did took place before.;
    public func isPurchased() -> Bool {
        let purchasesStatus = userDefaultsReference.bool(forKey: productID)
        
        if purchasesStatus {
            print("Previously Purchases it.")
            return true
        }
        else
        {
            print("Never Purchased the App.")
            return false
        }
    }
    
    func removingAllAds () {
        //Setting varieble to True;
        self.userDefaultsReference.set(true, forKey: productID)
        
    }
    
    //Tells the delegate an ad request failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        //If there's an request failed, go ahead & hide the banner..
        banner.isHidden = true

        //If the user already purchased the item to remove
        if isPurchased(){
            
            //If the user already removed all Ads;
            banner.isHidden = true
        }
        
    }
    
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) 
    {
        if isPurchased(){
            
            //If isPurchased function return value is True, then the user already removed the ads
            banner.isHidden = true
        }
        
        else{
            
            //User hasn't purchased the item to remove all Ads, show Ads;
            banner.isHidden = false
        }
    }
    
    //Showing the Ads;
    func showingBannerAds(){
        let removeAllAdsPurchase = self.userDefaultsReference.bool(forKey: productID)
        if(removeAllAdsPurchase){
            
            //If its true, remove All Ads;
            banner.isHidden = true

        }
        else
        {
            banner.isHidden = false

        }
        
    }
    
    //MARK: - In-App Method;
    func buyAppNoAds(){
        //Checking if the user can actually do the Purchase
        if SKPaymentQueue.canMakePayments(){
            
            //Creating a new Request;
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            //Below.., paymentObserver
            SKPaymentQueue.default().add(paymentRequest)
        }
        else{
            //Can't make the payment..
            print("Issues processing the payment. Unable to process your payment at this very moment.")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        //Checking each transactions
        for transaction in transactions{
            if transaction.transactionState == .purchased{
                
                //User Payment Successful :)
                print("Transaction Successful")
                
                //Removing AllAds;
                removingAllAds()
                
                //Alert Message: Thank you for the Purchase
                Alert.showAlertBox(on: self, with: "Your purchase has been successful ✅ ", message: "Thank you for your purchase 😄")
                
                //Purchase Successful, Hiding RemoveAds Button
                self.removeAdsLabel.isHidden = true
                
                //Purchases Successful, Hiding the BannerView
                self.banner.isHidden = true
             
                //Once the transaction has been completed, we would need to end the process.
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            else if transaction.transactionState == .failed {
                
                //If its not nil..
                if let error = transaction.error{
                    let errorDescription = error.localizedDescription
                    //User Payment Failed :(
                    print("Transaction Failed due to error \(errorDescription)")
                }
                
                //Once the transaction has been completed, we would need to end the process.
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }
            else if transaction.transactionState == .restored {
                
                //Alert Message: Restore Message;
                Alert.showAlertBox(on: self, with: "Your purchase has been restored ✅", message: "Enjoy our app without no ads 😄")
                
                //Restoring Purchase;
                removingAllAds()
                print("Transaction Fully Restored")
                
                //If Restore Process is Successful, Hiding the BannerView..
                self.banner.isHidden = true
                
                //Once it gets restored, go ahead ahead and hide the text from the View Controller
                self.removeAdsLabel.isHidden = true
                
                //Terminating Transaction Queue;
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
        
        }
        
        
    }
    
    //Restore Purchases;
    func restorePurchases(){
        //This would restore all previous purchases for the user;
        SKPaymentQueue.default().restoreCompletedTransactions()
     
    }
 
    //Checking for User permissions;
    func checkUserPermissions(){
        let notificationsCenter = UNUserNotificationCenter.current()
        notificationsCenter.getNotificationSettings{settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            
            case .denied:
            return
                
            case .notDetermined:
                notificationsCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification(){
        
        let identifierWednesday = "SplitClever Notification Wednesday"
        let identifierFriday = "SplitClever Notification Friday"
       
        
        //Previously: Having a dinner or a drink with your friends tonight? 🍽🍷
        let title = "Having dinner with friends tonight? 🍽🍷"
      
        //Previously: Split your bill today with Split Clever
        let body = "Split your dinner bill with Split Clever 😄"
        
        //Around 7pm
        let hour = 19
        let minute = 0
        
        //In order to change the content on the notification itself.
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        //Configuring Wednesday Trigger
        var dataComponentsWednesday = DateComponents()
        dataComponentsWednesday.hour = 19
        dataComponentsWednesday.minute = 0
        dataComponentsWednesday.weekday = 4
        let triggerWednesday = UNCalendarNotificationTrigger(dateMatching: dataComponentsWednesday, repeats: true)
        
        //Configuring Wednesday Trigger
        var dataComponentsFriday = DateComponents()
        dataComponentsFriday.hour = 19
        dataComponentsFriday.minute = 0
        dataComponentsFriday.weekday = 6
        let triggerFriday = UNCalendarNotificationTrigger(dateMatching: dataComponentsFriday, repeats: true)
        
        let notificationCenter = UNUserNotificationCenter.current()
     
        //Remove any previously scheduled notifications with the same identifier
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifierWednesday])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifierFriday])
        
        // Schedule the notification for Monday
        let requestWednesday = UNNotificationRequest(identifier: identifierWednesday, content: content, trigger: triggerWednesday)
                        notificationCenter.add(requestWednesday)
        let requestFriday = UNNotificationRequest(identifier: identifierFriday, content: content, trigger: triggerFriday)
                        notificationCenter.add(requestFriday)

    }
    
    //Setting actual UI background;
    func setMainbackground()
    {
        //Adding this specific View to the Parent View;
        view.addSubview(mainBackgroundImage)
        
        //Using No-AutoLayout
        mainBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        mainBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        mainBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //Loading UIImage;
        mainBackgroundImage.image = UIImage(named: "BaseBackground")
        
        //Setting Image to Fill the Screen; Previously .scaleToFill
        //scaleAspectFit doesn't suite the best
        //scaleAspectFill works fine.
        mainBackgroundImage.contentMode = .scaleAspectFill
        view.sendSubviewToBack(mainBackgroundImage)
         
    }
    
    //Restore All Ads & Buy App IBAction Buttons;
    @IBAction func removeAdsButton(_ sender: Any) 
    {
        //Purchase Payment Process:
        buyAppNoAds()
    }
    
    @IBAction func restoreAllPurchasesButton(_ sender: Any) {
        
        //Restore Purchases Process:
         restorePurchases()
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Calling function to the set the UI Background;
        setMainbackground()
                
        //Checking for User Permissions: Local Push Notifications..
        checkUserPermissions()
        
        //Assign ourselves to the Delegate Method:
        SKPaymentQueue.default().add(self)
        
        //Check if the user previously bought the app;
        if isPurchased(){
            
            //Removing All Ads from the App;
            removingAllAds()
        }
        else{
            //Since the user has not bought it before, show all Ads;
            showingBannerAds()
        }
        
        //Hiding the Navigation Back Arrow from the Navigation Controller
        self.navigationItem.hidesBackButton = true
        
        //Initial State: Hidden if there's no Ads to Show
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/8245251092"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
        
    }
    
}

