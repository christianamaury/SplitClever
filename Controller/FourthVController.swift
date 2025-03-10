//
//  FourthVController.swift
//  SplitClever
//
//  Created by Amaury C. Rivera on 3/4/25.
//

import UIKit

//Accessing Core Data Library
import CoreData

//Google Ads Library;
import GoogleMobileAds

class FourthVController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate
{
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var banner: GADBannerView!
    
    //Variable for the Randomizer Class;
    var desiredRandomNumber: Int = 2
    
    //Data Reference from the ViewController;
    let dataReference = ViewController()
    
    //Product ID: "SplitCleverNoAds" - No Ads on the application.
    let productID: String = "SplitCleverNoAds"

    //Array to store fetched Core Data Object;
    var savedSplitBillsData: [SplitEntity] = []
   
    //Background UIImage View;
    let mainBackgroundImage = UIImageView()
    
    //Tells the delegate an ad request loaded an Ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) 
    {
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
    
    //Tells the delegate an Ad Request Failed
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) 
    {
        banner.isHidden = true
        
        if(isPurchased())
        {
            banner.isHidden = true
        }
    }
    
    // If the application has been bought before;
     func isPurchased() -> Bool 
    {
        let purchasesStatus = dataReference.userDefaultsReference.bool(forKey: productID)
        if purchasesStatus 
        {
            //..Whether Shows Ads or Not;
            print("Previously Purchased")
            return true
        }
        
        else
        {
            print("Never Purchased")
            return false
        }
    }
    
    func showingBannerAds() 
    {
        let removeAllAdsPurchase = dataReference.userDefaultsReference.bool(forKey: productID)
        if(removeAllAdsPurchase)
        {
            //If its true, remove all Ads
            banner.isHidden = true
        }
        
        else
        {
            banner.isHidden = false
        }
    }
    
    func removingAllAds()
    {
        dataReference.userDefaultsReference.set(true, forKey: productID)
    }
    
    //Create/Load another secondary interstial Ads after the 1st one has been displayed;
    func createAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-3187572158588519/9010186782")
        inter.load(GADRequest())
        return inter
    }
    
    func setttingBackgroundImage()
    {
        //Adding this image to the Parent View;
        view.addSubview(mainBackgroundImage)
        
        //Using No-AutoLayout
        mainBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        mainBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //Loading up UI Background Image;
        mainBackgroundImage.image = UIImage(named: "BaseBackground")
        
        //Setting image to filled the screen;
        mainBackgroundImage.contentMode = .scaleAspectFill
        view.sendSubviewToBack(mainBackgroundImage)
        
    }

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        //Calling function to the set the UI Background;
        setttingBackgroundImage()
        
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
        
        //GoogleMobile Ads Banner Initial State: Hidden if there's no Ads to be display
        banner.isHidden = true
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3187572158588519/8245251092"
        banner.adSize = kGADAdSizeSmartBannerPortrait
        banner.rootViewController = self
        banner.load(GADRequest())
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.isEditing = true
        
        //Setitng the Back arrow on the Navigation Controller color to White;
        navigationController?.navigationBar.tintColor = .white
        
        //Setting the UITablew View to White Color
        dataTableView.backgroundColor = .white
        
        //Setting a Custom Corner Radius and shadowOpacity to the UITable View
        dataTableView.layer.cornerRadius = 5
        dataTableView.layer.shadowOpacity = 0.2
        
        //Fetching Core Data Mode
        savedSplitBillsData = CoreDataManager.shared.fetchData()
        
        //If there's no Data in the Persistance Container, display a message for the user
        if savedSplitBillsData.isEmpty 
        {
            Alert.showAlertBox(on: self, with: "No history yet!", message: "Time to add your first dinner split 🍽️")
        }
        else {return}
        
        //Reloading fetched Data;
        dataTableView.reloadData()
      
    }
    
    //How many rows there would be in my TableView;
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        //Returning the our array total elements (CoreData)
        return savedSplitBillsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        //Identifier for the Table Cell in the Table View: cell
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.layer.borderWidth = 0.5
        
        //Getting Saved Item Data;
        let savedItem = savedSplitBillsData[indexPath.row]
        
        //Assigning entitiy saved variables to the Cell Texts;
        //Also setting Black as the Text Color and white for the Cell Background;
        cell?.backgroundColor = .white
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.text = savedItem.splitTitle
        cell?.detailTextLabel?.textColor = .black
        cell?.detailTextLabel?.text = savedItem.stringAttribute
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle 
    {
        //Enables swipe to be delete
        return .delete
    }

    //Method to Delete a Cell;
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete 
        {
            //Calling our Deletion Function;
            deleteData(at: indexPath)
        }
    }
    
    // MARK: - Deleting Data;
    func deleteData(at indexPath: IndexPath)
    {
        let itemToBeDelete = savedSplitBillsData[indexPath.row]
        
        //Removing Data from Core Data;
        CoreDataManager.shared.deleteData(object: itemToBeDelete)
        
        //Removing Data from our Array variable;
        savedSplitBillsData.remove(at: indexPath.row)
        
        //Deleting the row from the TablewView with: .automatic effect
        //There's another effect called: .fade
        dataTableView.deleteRows(at: [indexPath], with: .automatic)
    }
   
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
