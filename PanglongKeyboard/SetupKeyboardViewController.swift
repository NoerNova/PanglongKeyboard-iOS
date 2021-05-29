//
//  SetupKeyboardController.swift
//  PanglongKeyboard
//
//  Created by NorHsangPha BoonHse on 27/5/2564 BE.
//

import UIKit

class SetupKeyboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var openSettingsButton: UIButton! {
        didSet {
            openSettingsButton.layer.cornerRadius = 10
        }
    }
    
    
    @IBAction func openSetupKeyboard(_ sender: UIButton) {
        self.setupKeyboard()
    }
    
    @objc func setupKeyboard() {
        let alertController = UIAlertController (title: "Keyboard Settings", message: "သႂ်ႇလွၵ်းမိုဝ်း", preferredStyle: .alert)

           let settingsAction = UIAlertAction(title: "Open", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }

               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
               }
           }
           alertController.addAction(settingsAction)
           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
           alertController.addAction(cancelAction)

           present(alertController, animated: true, completion: nil)
    }

}


