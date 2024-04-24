//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Karina Kovaleva on 24.04.24.
//

import Foundation

struct CalculationHistory {
    let date: String
    var calculation: [Calculation]
}

struct Calculation {
    let expression: [CalcuationHistoryItem]
    let result: Double
}

extension CalculationHistory: Codable {
}

extension Calculation: Codable {
}

extension CalcuationHistoryItem: Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case operation
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .number(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }
        
        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation),
           let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        
        throw CalculationHistoryItemError.itemNotFound
    }
}

class CalculationHistoryStorage {
    static let calculationHistoryKey = "calculationHistoryKey"
    
    func setHistory(calculation: [CalculationHistory]) {
        if let encoded = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    
    func loadHistory() -> [CalculationHistory] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey) {
            return (try? JSONDecoder().decode([CalculationHistory].self, from: data)) ?? []
        }
        return []
    }
}
