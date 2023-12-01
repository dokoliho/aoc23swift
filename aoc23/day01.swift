//
//  day00.swift
//  aoc23
//
//  Created by Oliver Hofmann on 1.12.23.
//

import Foundation

extension String {
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var calibration: Int {
        if let first_digit = (digits.first?.wholeNumberValue) {
            if let last_digit = (digits.last?.wholeNumberValue) {
                return first_digit*10+last_digit
            }
        }
        return 0
    }
    
    var realDigits: String {
        let translation_table = [   ("1", "1"), ("one", "1"),
                                    ("2", "2"), ("two", "2"),
                                    ("3", "3"), ("three", "3"),
                                    ("4", "4"), ("four", "4"),
                                    ("5", "5"), ("five", "5"),
                                    ("6", "6"), ("six", "6"),
                                    ("7", "7"), ("seven", "7"),
                                    ("8", "8"), ("eight", "8"),
                                    ("9", "9"), ("nine", "9"),
        ]
        var result = ""
        for(offset, _) in self.enumerated(){
            let startIndex = self.index(self.startIndex, offsetBy: offset)
            let substring = self[startIndex...]
            for (from, to) in translation_table {
                if substring.hasPrefix(from) {
                    result.append(to)
                }
            }
        }
        return result
    }
    
    var realCalibration: Int {
        if let first_digit = (realDigits.first?.wholeNumberValue) {
            if let last_digit = (realDigits.last?.wholeNumberValue) {
                print("\(first_digit*10+last_digit)")
                return first_digit*10+last_digit
            }
        }
        return 0
    }

    
}



struct Day01Solution : DailySolution {
    
    
    func solvePart1(puzzle: [String]) -> String {
        let calibration_numbers = puzzle.map{$0.calibration}
        return String(calibration_numbers.reduce(0, +))
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let calibration_numbers = puzzle.map{$0.realCalibration}
        return String(calibration_numbers.reduce(0, +))
    }
    
    
}
