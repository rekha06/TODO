//
//  ViewController.swift
//  Todo
//
//  Created by Rekha Ranjan on 6/23/20.
//  Copyright © 2020 Rekha Ranjan. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
   
    
    //MARK:- Datasource & UI Variables
    private var addedTodoItems = ToDoItems()
    @IBOutlet weak var tableView: UITableView!
    var selectedRows = [IndexPath]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults :[Todo]  = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      let searchBarScopeIsFiltering =
        searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive &&
        (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Todo List"
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
        self.tableView.tableFooterView = UIView()
        tableView.reloadData()
        
    }
    func filterContent(for searchText: String) {
      
        if let data  = self.addedTodoItems.todoItems {
            
          searchResults = data.filter { (item: Todo) -> Bool in
            return item.title!.lowercased().contains(searchText.lowercased())
           }
           
           tableView.reloadData()
        }
        
    }

    @IBAction func addtodoItem(_ sender: Any) {
       let todo = MainView().addtodo as AddTodoViewController
        todo.delegate = self
       self.navigationController?.pushViewController(todo, animated: true)
    }
    
    
}
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            // Reload the table view with the search result data.
            tableView.reloadData()
        }
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Todo Items"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering == true {
           return  searchResults.count
        }else{
        
        if let item  = addedTodoItems.todoItems {
            guard item.count > 0 else {
                
                return 0
            }
            return item.count
        }
        }
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as? TodoTableViewCell else {
            return UITableViewCell()
        }
          if let item  = addedTodoItems.todoItems {
            guard item.count > 0 else { return cell }
            let file = item[indexPath.row]
            cell.title.text = file.title?.uppercased()
            cell.desc.text = file.desc
            cell.downloadImage(from: file.imageUrl!)
            if file.isSelecetd == "0"{
               
               cell.btnCheckbox.setImage(#imageLiteral(resourceName: "uncheked"), for: .normal)
                cell.backgroundColor = UIColor.clear
                
            }else{
               cell.btnCheckbox.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                cell.backgroundColor = .lightGray
            }
            
      
            cell.btnCheckbox.isSelected = false
            if selectedRows.contains(indexPath) {
              cell.btnCheckbox.isSelected = true
            }
            cell.btnCheckbox.tag = indexPath.row
            cell.btnCheckbox.addTarget(self, action: #selector(btnCheckBoxClicked), for: .touchUpInside)
           
        }
 
        return cell
        
    }
    
    @objc func btnCheckBoxClicked(sender: UIButton){
        sender.isSelected = !sender.isSelected
        let indxPath = IndexPath(row: sender.tag, section: 0)
        if selectedRows.contains(indxPath) {
            CoreDataHelper.sharedInstance.updateData(isDone: "0", title: (addedTodoItems.todoItems?[sender.tag].title)!)
            selectedRows.remove(at: selectedRows.firstIndex(of: indxPath)!)
        } else {
            CoreDataHelper.sharedInstance.updateData(isDone: "1", title: (addedTodoItems.todoItems?[sender.tag].title)!)
            selectedRows.append(indxPath)
        }
       self.addedTodoItems = ToDoItems()
       self.tableView.reloadData()
        
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let todo = MainView().addtodo as AddTodoViewController
    todo.todoItem = self.addedTodoItems.todoItems![indexPath.row]
    self.navigationController?.pushViewController(todo, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
extension ViewController:AddTodoControllerDelegate{
    func notifyToHomeViewController() {
        self.addedTodoItems = ToDoItems()
        tableView.reloadData()
    }
    
    
}



