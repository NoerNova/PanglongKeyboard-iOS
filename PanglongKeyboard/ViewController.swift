//
//  ViewController.swift
//  PanglongKeyboard
//
//  Created by NorHsangPha BoonHse on 15/5/2564 BE.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - table Cell

        
        tableView.reloadData()
        tableView.cellForRow(at: [2,1])?.selectionStyle = .none
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let url = URL(string: "https://github.com/NoerNova/PanglongKeyboard-iOS") {
                    UIApplication.shared.open(url)
                }
            }
        }

    }
    

}
