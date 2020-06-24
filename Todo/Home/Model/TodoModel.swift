//
//  TodoModel.swift
//  Todo
//
//  Created by Rekha Ranjan on 6/24/20.
//  Copyright © 2020 Rekha Ranjan. All rights reserved.
//

import Foundation

struct ToDoItems {

    private (set) var  todoItems: [Todo]?

    init() {
           
           if let items = CoreDataHelper.sharedInstance.retrieveAllToDoItems(){
               let datSorted = items.sorted { (item1, item2) -> Bool in
                   if let title = item1.title, let title2 = item2.title{
                     return (title.localizedCaseInsensitiveCompare(title2) == .orderedDescending)

                    }
                   return true
               }
               self.todoItems  = datSorted.sorted(by: {Int($0.isSelecetd ?? "") ?? 0 < Int($1.isSelecetd ?? "") ?? 0})
           }
        
       }
}
