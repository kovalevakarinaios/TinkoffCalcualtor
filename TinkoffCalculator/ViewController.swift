//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 9.02.24.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .subtract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalcuationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    var calculationHistory: [CalcuationHistoryItem] = []
    var calculations: [CalculationHistory] = []
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttontext = sender.titleLabel?.text else { return }
        if buttontext == "," && self.label.text?.contains(",") == true {
            return
        }
        
        if self.label.text == "0" && buttontext != "," || self.label.text == "Ошибка" {
            self.label.text = buttontext
        } else {
            self.label.text?.append(buttontext)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttontext = sender.titleLabel?.text,
              let buttonOperation = Operation(rawValue: buttontext)
        else { return }
        
        guard let labelText = self.label.text,
              let labelNumber = self.numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        self.calculationHistory.append(.number(labelNumber))
        self.calculationHistory.append(.operation(buttonOperation))
        
        self.resetLabelText()
    }
    
    @IBAction func equalButtonPressed(_ sender: UIButton) {
        guard let labelText = self.label.text,
              let labelNumber = self.numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        self.calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try self.calculate()
            self.label.text = self.numberFormatter.string(from: NSNumber(value: result))
            self.makeCalculationHistory(result: result)
        } catch {
            self.label.text = "Ошибка"
        }
        self.calculationHistory.removeAll()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.calculationHistory.removeAll()
        self.resetLabelText()
    }
    
    @IBAction func showCalculationList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationListVC = sb.instantiateViewController(identifier: "CalculationListViewController")
        if let vc = calculationListVC as? CalculationListViewController {
            vc.calculations = self.calculations
        }
        self.navigationController?.pushViewController(calculationListVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetLabelText()
        self.historyButton.accessibilityIdentifier = "historyButton"
    }

    private func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }

    private func resetLabelText() {
        self.label.text = "0"
    }
    
    private func makeCalculationHistory(result: Double) {
        let currentDate = self.dateFormatter.string(from: Date())
        let currentCalculation = Calculation(expression: self.calculationHistory, result: result)
        var calculationAdded = false
        for (index, calc) in self.calculations.enumerated() {
            if calc.date == currentDate {
                self.calculations[index].calculation.append(currentCalculation)
                calculationAdded = true
                break
            }
        }
        if calculationAdded != true {
            self.calculations.append(CalculationHistory(date: currentDate, calculation: [currentCalculation]))
        }
    }
}

