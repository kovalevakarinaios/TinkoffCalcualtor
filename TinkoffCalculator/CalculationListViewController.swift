//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 21.04.24.
//

import UIKit

class CalculationListViewController: UIViewController {
    
    var result: String?
    
    @IBOutlet weak var calculationLabel: UILabel!
    
//    @IBAction func hideCalculationList(_ sender: Any) {
//        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
//    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.initialize()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.initialize()
//    }
//    
//    private func initialize() {
        // При modalPresentationStyle = .fullScreen UIkit убирает нижележащий VC, чтобы изменить это поведение используйте метод modalPresentationStyle = .overCurrentContext
//        self.modalPresentationStyle = .fullScreen
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculationLabel.text = self.result
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
}
