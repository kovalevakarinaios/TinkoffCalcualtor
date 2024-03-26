//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 9.02.24.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        print(label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
