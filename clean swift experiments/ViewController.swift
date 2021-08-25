//
//  ViewController.swift
//  clean swift experiments
//
//  Created by Kanaan Zafar on 20/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    /* override func viewDidLoad() {
     super.viewDidLoad()
     // Do any additional setup after loading the view.
     } */
    override func viewDidAppear(_ animated: Bool) {
        print("-------viewDidAppear: ")
        super.viewDidAppear(animated)
        
        guard let storyboard = storyboard else { return }
        let loginViewController = storyboard.instantiateViewController(identifier: "loginSegue")
        present(loginViewController, animated: false)
    }
}

