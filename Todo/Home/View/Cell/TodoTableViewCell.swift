//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Rekha Ranjan on 6/23/20.
//  Copyright © 2020 Rekha Ranjan. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
       @IBOutlet weak var circle: UIImageView!
       @IBOutlet weak var title: UILabel!
       @IBOutlet weak var desc: UILabel!
       @IBOutlet weak var btnCheckbox: UIButton!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }

       
       
   
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.circle.image = #imageLiteral(resourceName: "todo")// UIImage(data: data)
            }
        }
    }

   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
          URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
      }
}
