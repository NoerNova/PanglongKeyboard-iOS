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
        
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
////                setupKeyboard()
//            }
//        } else if indexPath.section == 1 {
//            if indexPath.row == 0 {
//                if let url = URL(string: "https://github.com/NoerNova/PanglongKeyboard-iOS") {
//                    UIApplication.shared.open(url)
//                }
//            }
//            else if indexPath.row == 1 {
//                print("License")
//            }
//        } else if indexPath.section == 2 {
//            if indexPath.row == 0 {
//                print("Version")
//            } else  if indexPath.row == 1 {
//                print("About")
//            }
//        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let url = URL(string: "https://github.com/NoerNova/PanglongKeyboard-iOS") {
                    UIApplication.shared.open(url)
                }
            }
        }

    }
    

}
