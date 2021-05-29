//
//  AboutViewController.swift
//  PanglongKeyboard
//
//  Created by NorHsangPha BoonHse on 29/5/2564 BE.
//

import SafariServices
import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func contactMe(_ sender: UIButton) {
        guard let url = URL(string: "https://www.noernova.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
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
