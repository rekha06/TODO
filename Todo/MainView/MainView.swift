//
//  MainView.swift
//
//
//  Created by Rekha on 24/06/20.
//  Copyright © 2020 Rekha. All rights reserved.
//

import UIKit

struct MainView {
    
    static private var storyBoard = UIStoryboard(name: "Main", bundle: nil)

    
    public var home : ViewController {
        MainView.storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    public var addtodo : AddTodoViewController {
        MainView.storyBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
    }
    
   
}
