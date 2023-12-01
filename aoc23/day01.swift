//
//  day01.swift
//  aoc23
//
//  Created by Oliver Hofmann on 01.12.23.
//

import Foundation

extension String {
    
    fileprivate func extractDigits(_ translationTable: [(String, String)]) -> String {
        var digits = ""
        for(offset, _) in self.enumerated() {
            let startIndex = self.index(self.startIndex, offsetBy: offset)
            let substring = self[startIndex...]
            for (from, to) in translationTable {
                if substring.hasPrefix(from) {
                    digits.append(to)
                    break
                }
            }
        }
        return digits
    }
    
    func calibrationValue(translationTable: [(String, String)] ) -> Int {
        let digits = extractDigits(translationTable)
        if let first_digit = (digits.first?.wholeNumberValue) {
            if let last_digit = (digits.last?.wholeNumberValue) {
                return first_digit*10+last_digit
            }
        }
        return 0
    }
    
}



public struct Day01Solution : DailySolution {

    let digitTable = [("1", "1"), ("2", "2"), ("3", "3"), ("4", "4"), ("5", "5"), ("6", "6"), ("7", "7"), ("8", "8"), ("9", "9")]
    let wordTable = [("one", "1"), ("two", "2"), ("three", "3"), ("four", "4"), ("five", "5"), ("six", "6"), ("seven", "7"), ("eight", "8"), ("nine", "9")]
    
    
    
    func solvePart1(puzzle: [String]) -> String {
        let calibrationValues = puzzle.map{$0.calibrationValue(translationTable: digitTable)}
        return String(calibrationValues.reduce(0, +))
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let calibrationValues = puzzle.map{$0.calibrationValue(translationTable: digitTable + wordTable )}
        return String(calibrationValues.reduce(0, +))
    }
    
    
}
