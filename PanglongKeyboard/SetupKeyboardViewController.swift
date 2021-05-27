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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            performSegue(withIdentifier: "UnwindToViewController", sender: self)
            
        }
    }
    
    
    
    @IBOutlet weak var openSettingsButton: UIButton! {
        didSet {
            openSettingsButton.layer.cornerRadius = 10
        }
    }
    
    
    @IBAction func dismissKeyboardSetup(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "UnwindToViewController", sender: self)
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
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       print("Settings opened: \(success)") // Prints true
                   })
               }
           }
           alertController.addAction(settingsAction)
           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
           alertController.addAction(cancelAction)

           present(alertController, animated: true, completion: nil)
    }

}


