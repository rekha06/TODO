//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Rekha Ranjan on 6/23/20.
//  Copyright © 2020 Rekha Ranjan. All rights reserved.
//

import UIKit

// MARK: Coredata notify
protocol AddTodoControllerDelegate: class {
    func notifyToHomeViewController()
}


class AddTodoViewController: UIViewController {
    weak var delegate :AddTodoControllerDelegate?
    var todoItem :Todo?
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txtField: UITextField!{
        didSet{
            
           
            txtField.isUserInteractionEnabled = true
            txtField.layer.cornerRadius = 8
            txtField.layer.borderWidth = 2
            txtField.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 89/255, alpha: 1).cgColor
            
        }
    }
    @IBOutlet weak var txtView: UITextView!{
        didSet{
          
            txtView.isUserInteractionEnabled = true
            txtView.layer.cornerRadius = 8
            txtView.layer.borderWidth = 2
            txtView.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 89/255, alpha: 1).cgColor
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Todo Item"
        guard self.todoItem != nil else {
            self.txtField.isUserInteractionEnabled = true
            self.txtView.isUserInteractionEnabled = true
            self.stackView.isHidden  = false
            self.navigationItem.hidesBackButton = true
            txtView.text = "Description"
            txtView.textColor = UIColor.lightGray
            txtView.becomeFirstResponder()
            return
        }
        txtView.text = todoItem!.desc
        txtField.text = todoItem!.title
        stackView.isHidden  = true
        self.navigationItem.hidesBackButton = false
        
        
        
    }
        
    
    
    @IBAction func onClickDoneButton(_ sender: Any) {
        
        saveItem()
        
    }
    @IBAction func onClickCancelButton(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveItem() {
        if let title = txtField.text , let desc = txtView.text {
            
            let dict :[String:Any] = ["title":title,"desc":desc,"isSelecetd":"0" ,"imageUrl":URL(string: "https://www.iconfinder.com/icons/791520/content_data_database_details_table_view_view_mode_icon")! as URL]
            if let _ = CoreDataHelper().addTodoItem(todoItem: dict), let delegate = delegate{
                delegate.notifyToHomeViewController()
                self.view.endEditing(true)
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
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
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
}
