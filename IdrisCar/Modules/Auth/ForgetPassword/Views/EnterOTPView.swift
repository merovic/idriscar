//
//  EnterOTPView.swift
//  IdrisCar
//
//  Created by Amir Morsy on 26/02/2025.
//

import UIKit

class EnterOTPView: UIViewController {

    @IBOutlet weak var verifyEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyEmailClicked(_ sender: Any) {
        let newViewController = NewPasswordView()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
