//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 21.04.24.
//

import UIKit

struct CalculationHistory {
    let date: String
    var calculation: [Calculation]
}

struct Calculation {
    let expression: [CalcuationHistoryItem]
    let result: Double
}

class CalculationListViewController: UIViewController {
   
    var calculations: [CalculationHistory] = []
    
    @IBOutlet weak var calculationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculationTableView.delegate = self
        self.calculationTableView.dataSource = self
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        self.calculationTableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
    }

    private func expressionToString(_ expression: [CalcuationHistoryItem]) -> String {
        var result = ""
        for operand in expression {
            switch operand {
            case let .number(value):
                result += String(value) + " "
            case let .operation(value):
                result += value.rawValue + " "
            }
        }
        return result
    }
}

extension CalculationListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.calculations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.calculations[section].date
    }
}

extension CalculationListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.calculations[section].calculation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.calculationTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        let historyItem = self.calculations[indexPath.section].calculation[indexPath.row]
        cell.configure(with: self.expressionToString(historyItem.expression), result: String(historyItem.result))
        return cell
    }
}
