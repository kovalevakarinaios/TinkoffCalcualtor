//
//  HistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 21.04.24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var expressionLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!

    func configure(with expression: String, result: String) {
        self.expressionLabel.text = expression
        self.resultLabel.text = result
    }
}
