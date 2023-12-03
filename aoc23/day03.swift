//
//  day03.swift
//  aoc23
//
//  Created by Oliver Hofmann on 03.12.23.
//

import Foundation

public struct Day03Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        return "1"
    }
    
    func solvePart2(puzzle: [String]) -> String{
        return "2"
    }
    
}


extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}

struct NumberParser {
    
    var row = 0
    var col = 0
    var processing = ""
    var attachedSymbolFound = false
    let engine : [String]
    
    init(_ schematic: [String]) {
        engine = schematic
    }
    
    mutating func nextNumber() -> (Int?, Bool) {
        if row >= engine.count {
            return (nil, false)
        }
        if col >= engine[row].count || !engine[row][col].isNumber {
            step()
            if !processing.isEmpty {
                let value = Int(processing)
                let valid = attachedSymbolFound
                processing = ""
                attachedSymbolFound = false
                return (value, valid)
            }
            return nextNumber()
        }
        processing.append(engine[row][col])
        //TODO: Check attachedSymbolFound
        step()
        return nextNumber()
    }
    
    mutating func step() {
        if row >= engine.count {
            return
        }
        if col >= engine[row].count {
            col = 0
            row += 1
            return
        }
        col += 1
    }
}
