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
    let yourPortion = ["Your Split (includes tip) 💵💡"]
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
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.isEditing = true
        
        //TESTING; Styling;
        dataTableView.layer.cornerRadius = 5
        
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
        
        cell?.textLabel?.text = savedItem.splitTitle
        cell?.detailTextLabel?.text = savedItem.stringAttribute
        
        //TEtING;
        //dataTableView.reloadData()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        //Enables swipe to be delete
        return .delete
       
    }
////    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            
            //Calling our Deletion Function;
            deleteData(at: indexPath)
        }
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
//               
//               // Call the delete function
//               self.deleteData(at: indexPath)
//               
//             //Notify the system that the action was performed
//               completionHandler(true)
//           }
////            // ✅ Allows tap to delete instead of full swipe
////            let config = UISwipeActionsConfiguration(actions: [deleteAction])
////            config.performsFirstActionWithFullSwipe = false
////        
////            return config
//             return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
    // MARK: - Deleting Data;
    func deleteData(at indexPath: IndexPath)
    {
        let itemToBeDelete = savedSplitBillsData[indexPath.row]
        
        //Removing from Core Data;
        CoreDataManager.shared.deleteData(object: itemToBeDelete)
        
        //Removing from the Array;
        savedSplitBillsData.remove(at: indexPath.row)
        
        //Deleting the row from the TablewView with an animation
        //.fade
        dataTableView.deleteRows(at: [indexPath], with: .automatic)
        
        //TESTING;
        //dataTableView.reloadData()
        
        //TESTING:
  // ✅ Reload the table properly
//            dataTableView.performBatchUpdates {
//                dataTableView.deleteRows(at: [indexPath], with: .fade)
//            } completion: { _ in
//                 // ✅ Fetch fresh data after deletion
//                self.savedSplitBillsData = CoreDataManager.shared.fetchData()
//                self.dataTableView.reloadData()
//            }
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
