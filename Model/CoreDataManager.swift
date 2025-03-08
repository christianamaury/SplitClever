//
//  CoreDataManager.swift
//  SplitClever
//
//  Created by Amaury C. Rivera on 3/7/25.
//

import Foundation
import UIKit

import CoreData

class CoreDataManager {
    
    //Singleton Process
    static let shared = CoreDataManager()
    
    //Private init so I can prevent multiple Instances;
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Saving new Data into Core Data
    func saveData(splitTitle: String, splitPersonData: String){
                let newSplitPersonData = SplitEntity(context: context)
                
                //Assigning data to the Core Object ;
                newSplitPersonData.stringAttribute = splitPersonData
                newSplitPersonData.splitTitle = splitTitle
                
                do{
                    //Handling any potential errors; Saving actual Data;
                    try context.save()
                }
                
                catch {
                    print("❌ Error saving \(error)")
                }
        
        //Reloading Data;
        fetchData()
        
    }
    
    // MARK: - Fetching Data
    func fetchData () -> [SplitEntity]
    {
        let request: NSFetchRequest<SplitEntity> = SplitEntity.fetchRequest()
        var results: [SplitEntity] = []
        
        do{
            //Load Data
            results = try context.fetch(request)
        }
        
        catch{
            print("❌ Error Fetching Data \(error)")
        }
        
        return results
        
    }
    
    // MARK: - Deleting Data, Core Data
    func deleteData(object: NSManagedObject){
        
        //Deleting from Core Data;
        context.delete(object)
        
        do{
            //Saving Deleting Changes;
            try context.save()
        }
        
        catch{
            print ("❌ Error Deleting: \(error)")
        }
    }
      
    
}
