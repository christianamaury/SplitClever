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

class FourthVController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var dataTableView: UITableView!
    
    //Testing Fake Data for testing purposes on the TableView;
    let fruits = ["Apple", "Pinneapple", "Banana"]
    let prices = [0.99, 1.23, 3.44]
    
    //Variable to receive Data from the ThirdView Controller
    var splitReceivedData: String?
    
    //..Array to store fetched Core Data Objects;
    var savedSplitBillsData: [SplitEntity] = []
    
    //Getting Core Data Context from our App Delegate;
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        
    //Background UIImage View;
    let mainBackgroundImage = UIImageView()
    
    func setttingBackgroundImage()
    {
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        //Adding this image to the Parent View;
        view.addSubview(mainBackgroundImage)
        
        //Using No-AutoLayout
        mainBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        mainBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //Loading up background image;
        mainBackgroundImage.image = UIImage(named: "BaseBackground")
        
        //Setting image to filled the screen;
        mainBackgroundImage.contentMode = .scaleAspectFill
        view.sendSubviewToBack(mainBackgroundImage)
        
    }

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        //TESTING: Core Datat;
        savedSplitBillsData = CoreDataManager.shared.fetchData()
        dataTableView.reloadData()
        
        //saveData(splitPersonData: splitReceivedData!)

        // Do any additional setup after loading the view.
        
        //Calling function to the set the UI Background;
        setttingBackgroundImage()
    }
    
    //How many rows there would be in my TableView;
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Just return the array of the
        //return fruits.count
        
        //Using the actual Core Data Array
        //return savedSplitBillsData.count
        
        return savedSplitBillsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        //Identifier for the Table Cell in the Table View: cell
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell")
        
        //Assigning array names to the cell: FAKE DATA, TESTING:
//         cell?.textLabel?.text = fruits[indexPath.row]
//         cell?.detailTextLabel?.text = "\(prices[indexPath.row])"
        
        //Getting Saved Item Data;
        let savedItem = savedSplitBillsData[indexPath.row]
        
        cell?.textLabel?.text = savedItem.stringAttribute
        cell?.detailTextLabel?.text = savedItem.stringAttribute
        
        //TEtING;
        //dataTableView.reloadData()
        
        return cell!
    }
    
//    // MARK: - Saves new tabs per Person into Core Data
//    func saveData(splitPersonData: String) {
//        
//        let newSplitPersonData = SplitEntity(context: context)
//        newSplitPersonData.stringAttribute = splitPersonData
//        
//        do{
//            //Saving to Core Data
//            try context.save()
//        }
//        
//        catch{
//            print("❌ Error saving: \(error)")
//        }
//        
//        //Reloading
//        fetchData()
//        
//    }
    
//    // MARK: - Fetchig Data
//    func fetchData(){
//        
//        let request: NSFetchRequest<SplitEntity> = SplitEntity.fetchRequest()
//        
//        do{
//            savedSplitBillsData = try context.fetch(request)
//            dataTableView.reloadData()
//            
//        }
//        
//        catch{
//            print ("❌ Error fetching data: \(error)")
//        }
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
