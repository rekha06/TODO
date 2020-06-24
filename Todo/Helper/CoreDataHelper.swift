//
//  CoreDataHelper.swift
//  BUK
//
//  Created by Rekha on 24/06/20.
//  Copyright © 2020 Rekha. All rights reserved.
//

import UIKit
import CoreData

@objc class CoreDataHelper: NSObject {
    
    static let sharedInstance = CoreDataHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func retrieveAllToDoItems() ->[Todo]?{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Todo")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count > 0
            {
                return results as? [Todo]
            }
        }
        catch let error as NSError {
            Swift.debugPrint("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil
        
    }
    
    func addTodoItem(todoItem:[String:Any]) -> Todo? {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entityDescription =  NSEntityDescription.entity(forEntityName: "Todo", in: managedContext) else { return nil }
        let item = Todo(entity: entityDescription, insertInto: managedContext)
        
        item.title     = todoItem["title"] as? String
        item.desc  =  todoItem["desc"] as? String
        item.isSelecetd =  todoItem["isSelecetd"] as? String
        item.imageUrl =  todoItem["imageUrl"] as? URL
        
        do {
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
        return item
    }
    
    func updateData(isDone:String,title :String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do
        {
            let fetchResults = try managedContext.fetch(fetchRequest)
            let resultData = fetchResults as! [Todo]
           if resultData.count != 0 {
               for object in resultData {
                    if object.title ==  title {
                        object.isSelecetd = isDone
                    }
                }
            }
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
   
    
    
}
