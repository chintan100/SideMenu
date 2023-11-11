//
//  SideMenuViewController.swift
//  SideMenu
//
//  Created by Chintan Patel on 11/11/23.
//

import Foundation
import UIKit

protocol SideMenuViewControllerDelegate {
    
    func didSelectCell(_ row: Int, title: String)
}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var sideMenuTableView: UITableView!
    
    var delegate: SideMenuViewControllerDelegate?
    
    var titlesArray: [String] = ["Your Activity",
                                 "Profile",
                                 "Downloads",
                                 "Settings",
                                 "Logout"]

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        
        let label = cell.contentView.viewWithTag(1) as! UILabel
        
        label.font = label.font.withSize(20)
        label.text = self.titlesArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.didSelectCell(indexPath.row, title: self.titlesArray[indexPath.row])
    }
}
