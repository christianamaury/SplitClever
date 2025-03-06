//
//  SecondVController.swift
//  SplitClever
//
//  Created by Amaury C. Rivera on 1/23/24.
//

import UIKit
import Foundation

//Importing GoogleMobile Ads Library
import GoogleMobileAds

class SecondVController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate
{
    //BannerView Reference; 
    @IBOutlet weak var banner: GADBannerView!
    var interstitial: GADInterstitial!
    
    //Google Ads Test Units:
    //iOS Test Ads Unit: ca-app-pub-3940256099942544/2934735716
    //iOS Test Interestiads Ads: ca-app-pub-3940256099942544/4411468910
    //Real Interestial Ads: ca-app-pub-3187572158588519/9010186782
    //Real Banner Ads: ca-app-pub-3187572158588519/8245251092
    
    //Bill Amount Text Field Reference..
    @IBOutlet weak var billAmountTextField: UITextField!
    
    //Bool variable to check if all textFields has been entered;
    //If true, we can move to the next Controller..
    var splitBillVerifier: Bool = false
    
    //Product ID: "SplitCleverNoAds" - No Ads on the application.
    let productID: String = "SplitCleverNoAds"
    
    //Bill Amount Int for String Conversion Purposes..;
    var billAmountTextFieldEntered: Double = 0
    
    //Custom Tip Percentage entered by the user;
    var customTipEntered: Double = 0
    
    //Variable use for the RandomInterestial Ads;
    var desiredNumber: Int = 0
    
    //Keep result information from the user
    //Initially tabPerPerson was an Int
    var tabPerPerson: Double = 0
    var tabPerPersonString: String? = ""
    var tipPerPerson: Double = 0
    var tipRoundedPercentage: Double = 0
    var totalPerPerson: Double = 0
    var grantTotalBill: Double = 0
    var grantTotalTipPercentage: Double = 0
    var tenPercentageVar: Bool = false
    var fiftenPercentageVar: Bool = false
    
    
    //Split Bill Results..;
    var splitBillResults: Int = 0
    
    //Group of People Text Field Reference..
    @IBOutlet weak var groupOfPeopleTextField: UITextField!
    //..Group of People Int for String Conversion Purposes..;
    var groupOfPeolpleTextFieldEntered: Double = 0
    
    //Custom Tip Amount Reference..
    @IBOutlet weak var customTipAmount: UITextField!
    //Custom Tip Amount for String Conversion Purposes..
    var customTipAmountEntered: Int = 0
    
    //IBOutlet References for the percentages Buttons;
    @IBOutlet weak var tenButton: UIButton!
    @IBOutlet weak var fifteenButton: UIButton!
    @IBOutlet weak var twentyFiveButton: UIButton!
    
    //UIImageView for the Background
    let mainBackgroundImage = UIImageView()
    
    //UserDataReference from the MainViewController;
    let dataReference = ViewController()
    
    //15% IBAction Button..
    @IBAction func fifteenPercentageButton(_ sender: UIButton)
    {
        fifteenPercentageFunction()
        
    }
    
    //25% IBAction Button..
    @IBAction func twentyFivePercentageButton(_ sender: UIButton)
    {
        twentyFivePercentageFunction()
        
    }
    
    //10% IBAction Button..
    @IBAction func tenPercentageButton(_ sender: UIButton)
    {
        tenPercentageFunction()
    }
    
    //Setting UI background
    func setMainbackground(){
        
        //Adding this specific View to the Parent View;
        view.addSubview(mainBackgroundImage)
        
        //Using No-AutoLayout
        mainBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        //Top of our ImageView is pin to the Top of the Screen;
        mainBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //Image to Load;
        mainBackgroundImage.image = UIImage(named: "MainBackground")
        
        //Setting Image to Fill the Screen; Previously .scaleToFill
        mainBackgroundImage.contentMode = .scaleAspectFill
        
        view.sendSubviewToBack(mainBackgroundImage)
        
    }
    
    func tenPercentageFunction()
    {
        if(billAmountTextField.text != "" && groupOfPeopleTextField.text != "")
        {
            //Assigning the Bill Amount entered by the user;
            billAmountTextFieldEntered = Double(billAmountTextField.text!)!
            
            //Assigning the group of People entered by the user;
            groupOfPeolpleTextFieldEntered = Double(groupOfPeopleTextField.text!)!
            
            //Bill Amount / Group of People
            tabPerPerson = Double(billAmountTextFieldEntered) / Double(groupOfPeolpleTextFieldEntered)
            
            let decimalTipPerPerson = tipPerPerson.truncatingRemainder(dividingBy: 1)
           
            tipPerPerson = tabPerPerson * 0.10
            
            if decimalTipPerPerson > 0.99 {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else{
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tipPerPerson = Double(round(100 * tipPerPerson) / 100)
            }
            
            //Total Per Person..
            totalPerPerson = tabPerPerson + Double(tipPerPerson)
            
            //Grant Group Bill Total
            grantTotalTipPercentage = billAmountTextFieldEntered * 0.10
            grantTotalTipPercentage = grantTotalTipPercentage + billAmountTextFieldEntered
            grantTotalBill = grantTotalTipPercentage
  
            //Checking if the Decimal is greater than the second integer;
            //The truncatingRemainder returns the remainder of this value divided by the given value
            let decimalDouble = totalPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalTabPerPerson = tabPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalGrantTotalBill = grantTotalBill.truncatingRemainder(dividingBy: 1)
            
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            if decimalDouble > 0.99 {
                
                //Value stays the same;
            }
            else{
                
                //Decimal isn't greater than the second integer value, rounded it up;
                totalPerPerson = Double(round(100 * totalPerPerson) / 100)
            }
        
            //If statement for TabPerPerson Variable;
            if decimalTabPerPerson > 0.99 {
                
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else{
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tabPerPerson = Double(round(100 * tabPerPerson) / 100)
            }
            
            //If statement for GrantTotal Variable;
            if decimalGrantTotalBill > 0.99 {
                
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else
            {
                
                //Decimal isn't greater than the second integer value, rounded it up;
                grantTotalBill = Double(round(100 * grantTotalBill) / 100)
            }
            
            //Hidding all IBOutlets Buttons and TextField;
            fifteenButton.isHidden = true
            twentyFiveButton.isHidden = true
            customTipAmount.isHidden = true
            
            //Boolean set to True now: True
            splitBillVerifier = true
          
        }
        else 
        {
            
            Alert.showAlertBox(on: self, with: "Sorry, we're missing some required information❗️", message: "Please make sure to enter all the required information ✅")
        }
    }
    
    func fifteenPercentageFunction(){
        
        if(billAmountTextField.text != "" && groupOfPeopleTextField.text != "")
        {
            //Assigning the Bill Amount entered by the user;
            billAmountTextFieldEntered = Double(billAmountTextField.text!)!
            
            //Assigning the group of People entered by the user;
            groupOfPeolpleTextFieldEntered = Double(groupOfPeopleTextField.text!)!
            
            //Bill Amount / Group of People
            tabPerPerson = Double(billAmountTextFieldEntered) / Double(groupOfPeolpleTextFieldEntered)
                        
            let decimalTipPerPerson = tipPerPerson.truncatingRemainder(dividingBy: 1)
            
            //Example: $14.29 * 10 = $1.43
            tipPerPerson = tabPerPerson * 0.15
            
            if decimalTipPerPerson > 0.99 {
                
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else
            {
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tipPerPerson = Double(round(100 * tipPerPerson) / 100)
            }
            
            //Total Per Person..
            totalPerPerson = tabPerPerson + Double(tipPerPerson)
            
            //Grant Bill Total..
            grantTotalTipPercentage = billAmountTextFieldEntered * 0.15
            grantTotalTipPercentage = grantTotalTipPercentage + billAmountTextFieldEntered
            grantTotalBill = grantTotalTipPercentage
            
            
            //Checking if the Decimal is greater than the second integer;
            //The truncatingRemainder returns the remainder of this value divided by the given value
            let decimalDouble = totalPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalTabPerPerson = tabPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalGrantTotalBill = grantTotalBill.truncatingRemainder(dividingBy: 1)
            
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            if decimalDouble > 0.99 
            {
                //Value stays the same;
            }
            else
            {
                //Decimal isn't greater than the second integer value, rounded it up;
                totalPerPerson = Double(round(100 * totalPerPerson) / 100)
            }
            
            //If Statemeent For TabPerPerson;
            if decimalTabPerPerson > 0.99 
            {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else
            {
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tabPerPerson = Double(round(100 * tabPerPerson) / 100)
            }
            
            //If Statemeent For GrantTotal;
            if decimalGrantTotalBill > 0.99 {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else{
                
                //Decimal isn't greater than the second integer value, rounded it up;
                grantTotalBill = Double(round(100 * grantTotalBill) / 100)
            }
            
            //Hidding all IBOutlets Buttons and TextField;
            tenButton.isHidden = true
            twentyFiveButton.isHidden = true
            customTipAmount.isHidden = true
            
            //Boolean set to True now: True
            splitBillVerifier = true
            
        }
        else
        {
            Alert.showAlertBox(on: self, with: "Sorry, we're missing some required information❗️", message: "Please make sure to enter all the required information ✅")
        }
    }
    
    func twentyFivePercentageFunction()
    {
        if(billAmountTextField.text != "" && groupOfPeopleTextField.text != "")
        {
            
            //Assigning the Bill Amount entered by the user;
            billAmountTextFieldEntered = Double(billAmountTextField.text!)!
            
            //Assigning the group of People entered by the user;
            groupOfPeolpleTextFieldEntered = Double(groupOfPeopleTextField.text!)!
            
            //Bill Amount / Group of People
            tabPerPerson = Double(billAmountTextFieldEntered) / Double(groupOfPeolpleTextFieldEntered)
                        
            let decimalTipPerPerson = tipPerPerson.truncatingRemainder(dividingBy: 1)
            
            //Example: $14.29 * 10 = $1.43
            tipPerPerson = tabPerPerson * 0.25
            
            if decimalTipPerPerson > 0.99 
            {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else{
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tipPerPerson = Double(round(100 * tipPerPerson) / 100)
            }
            //Total Per Person..
            totalPerPerson = tabPerPerson + Double(tipPerPerson)
            
            //Grant Bill Total..
            grantTotalTipPercentage = billAmountTextFieldEntered * 0.25
            grantTotalTipPercentage = grantTotalTipPercentage + billAmountTextFieldEntered
            grantTotalBill = grantTotalTipPercentage
            
            //Checking if the Decimal is greater than the second integer;
            //The truncatingRemainder returns the remainder of this value divided by the given value
            let decimalDouble = totalPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalTabPerPerson = tabPerPerson.truncatingRemainder(dividingBy: 1)
            let decimalGrantTotalBill = grantTotalBill.truncatingRemainder(dividingBy: 1)
            
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            if decimalDouble > 0.99 
            {
                //Value stays the same;
            }
            else
            {
                //Decimal isn't greater than the second integer value, rounded it up;
                totalPerPerson = Double(round(100 * totalPerPerson) / 100)
            }
            
            //If Statement for TabPerPerson Variable;
            if decimalTabPerPerson > 0.99 
            {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else
            {
                
                //Decimal isn't greater than the second integer value, rounded it up;
                tabPerPerson = Double(round(100 * tabPerPerson) / 100)
            }
            
            //If Statement for GrantTotalBill Variable;
            if decimalGrantTotalBill > 0.99 {
                //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
            }
            else
            {
                //Decimal isn't greater than the second integer value, rounded it up;
                grantTotalBill = Double(round(100 * grantTotalBill) / 100)
            }
    
            //Hidding all IBOutlets Buttons and TextField;
            tenButton.isHidden = true
            fifteenButton.isHidden = true
            customTipAmount.isHidden = true
            
            //Boolean set to True now: True
            splitBillVerifier = true
         
        }
        else
        {
            Alert.showAlertBox(on: self, with: "Sorry, we're missing some required information❗️", message: "Please make sure to enter all the required information ✅")
        }
        
    }
    
    func customerCustomTip(){
        
            //Assigning the Bill Amount entered by the user;
        billAmountTextFieldEntered = Double(billAmountTextField.text!)!
            
            //Assigning the group of People entered by the user;
        groupOfPeolpleTextFieldEntered = Double(groupOfPeopleTextField.text!)!
        
        
        tabPerPerson = Double(billAmountTextFieldEntered) / Double(groupOfPeolpleTextFieldEntered)
        
        let decimalTipPerPerson = tipPerPerson.truncatingRemainder(dividingBy: 1)
        //$14.29 * 10 = $1.43
        tipPerPerson = Double(customTipAmount.text!)!
        
        //Dividir entre las personas del Party;
        tipPerPerson = tipPerPerson / groupOfPeolpleTextFieldEntered
        
        if decimalTipPerPerson > 0.99 {
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
        }
        else
        {
            //Decimal isn't greater than the second integer value, rounded it up;
            tipPerPerson = Double(round(100 * tipPerPerson) / 100)
        }
        
        //Total Per Person..
        totalPerPerson = tabPerPerson + Double(tipPerPerson)
        
        //Grant Group Bill Total
        customTipEntered = Double(customTipAmount.text!)!
        grantTotalTipPercentage = billAmountTextFieldEntered + customTipEntered
        grantTotalBill = grantTotalTipPercentage
        
        //Checking if the Decimal is greater than the second integer;
        //The truncatingRemainder returns the remainder of this value divided by the given value
        let decimalDouble = totalPerPerson.truncatingRemainder(dividingBy: 1)
        let decimalTabPerPerson = tabPerPerson.truncatingRemainder(dividingBy: 1)
        let decimalGrantTotalBill = grantTotalBill.truncatingRemainder(dividingBy: 1)
        
        //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
        if decimalDouble > 0.99 
        {
            //Value stays the same;
        }
        else
        {
            //Decimal isn't greater than the second integer value, rounded it up;
            totalPerPerson = Double(round(100 * totalPerPerson) / 100)
        }
    
        //If statement for TabPerPerson Variable;
        if decimalTabPerPerson > 0.99 
        {
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
        }
        else
        {
            
            //Decimal isn't greater than the second integer value, rounded it up;
            tabPerPerson = Double(round(100 * tabPerPerson) / 100)
        }
        
        //If statement for GrantTotal Variable;
        if decimalGrantTotalBill > 0.99 
        {
            //If the deciumal is greater than the second integer value, stays the same value, nothing won't change.
        }
        else
        {
            
            //Decimal isn't greater than the second integer value, rounded it up;
            grantTotalBill = Double(round(100 * grantTotalBill) / 100)
        }


    }

    //IBAction Button to Enable all IBOutlets;
    @IBAction func resetTipButtons(_ sender: UIButton) 
    {
        splitBillVerifier = false
        
        tenButton.isHidden = false
        fifteenButton.isHidden = false
        twentyFiveButton.isHidden = false
        customTipAmount.isHidden = false
    }
    
    //IBAction Button to the ThirdView Controller
    @IBAction func sliptBillButton(_ sender: UIButton) 
    {
        
        if(billAmountTextField.text != "" && groupOfPeopleTextField.text != "")
        {
            
            if let customTipText = customTipAmount.text, !customTipText.isEmpty
            {
                splitBillVerifier = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    
                    //Hide Percentages Buttons;
                    //Hidding all IBOutlets Buttons and TextField;
                    self.tenButton.isHidden = true
                    self.fifteenButton.isHidden = true
                    self.twentyFiveButton.isHidden = true
                }
                //Custom Tip Function which does the custom math for the Customer;
                customerCustomTip()
                
            }
            
            else if(billAmountTextField.text == "" && groupOfPeopleTextField.text == "" && splitBillVerifier == false)
            {
                Alert.showAlertBox(on: self, with: "Sorry, we're missing some required information❗️", message: "Please make sure to enter all the required information ✅")
                return
            }
            
        }
        
            if(splitBillVerifier == true)
            {
                //Showing Interestial Ads;
                randomInterestialAds()
                
                //Performing Segue:
                performSegue(withIdentifier: "ThirdVControllerIdentifier", sender: self)
                
            }
            else {
                Alert.showAlertBox(on: self, with: "Sorry, we're missing some required information❗️", message: "Please make sure to enter all the required information ✅")
                return
            }
        
    }
    
    //Third View Controller Identifier: ThirdVControllerIdentifier
    //Transferring Data to the Third View Controller;
    //Preparing Segue data to the ThirdVController;
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Assigning ThirdVController as our Destination to our Varibale..
        let thirdViewController = segue.destination as! ThirdVController
        if(splitBillVerifier == true)
        {
            thirdViewController.tabPerPersonString = String(tabPerPerson)
            thirdViewController.tipPerPersonString = String(tipPerPerson)
            thirdViewController.totalPerPersonString  = String(totalPerPerson)
            thirdViewController.grantTotalBillString = String(grantTotalBill)

        }
        else{
            
            return
        }
    }
    

    // MARK: - Random Interestial Ads;
    func randomInterestialAds() 
    {
        
        desiredNumber = 1
        //Initial Default: (0..4) - Unfortunately it was taking too long to display an ad.
        var randomNumber = Int.random(in: 0...2)
        //In order to show the Ads, the number needs to be: 2
        if(desiredNumber == randomNumber)
        {
            if(isPurchased()){
              
                //Do not display any Ads. Remove All Interestial Ads.
                print("User already removed the Ads")
            }
            else
            {
            //Showing Interstial Ads to the user, User haven't removed all Ads;
            showInterstitial()
                
            }
        }
        
        else 
        {
            //Previously it was set to 0
            desiredNumber = 1
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
    
    func appUseIntructions(){
        Alert.showAlertBox(on: self, with: "How to use Split Clever 🧾😄", message: "Make sure to enter your bill amount and the number of people in your party. Once this information has been entered, you can select your desired tip percentage or rather enter your prefered custom tip amount.                   (As an example: 3.00 dollars) ✅")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //App Instructions;
        appUseIntructions()
        
        //Calling function to the set the UI Background;
        setMainbackground()
        
        //Setting image for the background textField;
        let backgroundImage = UIImage(named: "BillAmountButton")
        billAmountTextField.background = backgroundImage
        groupOfPeopleTextField.background = backgroundImage
        customTipAmount.background = backgroundImage
        
        //Return key purposes when the user do an input;
        billAmountTextField.delegate = self
        customTipAmount.delegate = self
        groupOfPeopleTextField.delegate = self
        
        
        //Custom RGB Color: *A41C24* for the Place Holder;
        let red: CGFloat = 164.0 / 255.0
        let green: CGFloat = 28.0 / 255.0
        let blue: CGFloat = 36.0 / 255.0
        let customColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        //Assigning the Custom Color to the Placeholder itself.
        let placeHolder = NSAttributedString(string: "Enter Bill?", attributes: [NSAttributedString.Key.foregroundColor: customColor])
        
        let groupOfPeoplePlaceHolder = NSAttributedString(string: "1 or 2, etc?", attributes: [NSAttributedString.Key.foregroundColor: customColor])
        
        let customTipPlacerHolder = NSAttributedString(string: "CUSTOM TIP?", attributes: [NSAttributedString.Key.foregroundColor: customColor])
        
        //Placeholder and Text Color;
        billAmountTextField.attributedPlaceholder = placeHolder
        groupOfPeopleTextField.attributedPlaceholder = groupOfPeoplePlaceHolder
        customTipAmount.attributedPlaceholder = customTipPlacerHolder

        //Check if the user previously bought the app;
        if isPurchased(){
            
            //Removing All Ads from the App;
            removingAllAds()
        }
        else{
            //Since the user has not bought it before, show all Ads;
            showingBannerAds()
        }
        
        //Initial State: Hidden if there's no Ads to the Show;
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/8245251092"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
        
        //Requesting-Intertestial Ads:
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3187572158588519/9010186782")
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
}

//Extension to the Third ViewController: UITextFieldDelegate
extension SecondVController: UITextFieldDelegate{
    
    //It's called whenever the return key has been pressed, return NO to ignore;
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        billAmountTextField.resignFirstResponder()
        groupOfPeopleTextField.resignFirstResponder()
        customTipAmount.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Only these characters are allow to be enter on these input text fields;
    func textField(_ billAmountTextField: UITextField,_ groupOfPeopleTextField: UITextField,_ customTipAmount:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Allowed Characters to input on the TextField
        let allowedCharacters = "1234567890."
        let characterSet = CharacterSet(charactersIn: allowedCharacters)
        for character in string {
            if !characterSet.contains(character.unicodeScalars.first!)
            {
                //Entered Character isn't allowed
                //Showing an invalid input message for the user:
                Alert.showAlertBox(on: self, with: "Sorry, try again 😅", message: "Please make sure to enter a number in the required field ✅")
                return false
            }
        }
        
        return true
    }
    

}
