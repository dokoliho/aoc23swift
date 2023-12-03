//
//  day03.swift
//  aoc23
//
//  Created by Oliver Hofmann on 03.12.23.
//

import Foundation

public struct Day03Solution : DailySolution {

    
    func solvePart1(puzzle: [String]) -> String {
        var parser = NumberParser(puzzle)
        var number : Int?
        repeat {
            (number, _) = parser.nextNumber()
        } while (number != nil)
        return String(parser.sumValidNumbers())
    }

    
    func solvePart2(puzzle: [String]) -> String{
        var parser = NumberParser(puzzle)
        var number : Int?
        repeat {
            (number, _) = parser.nextNumber()
        } while (number != nil)
        return String(parser.sumOfGearRatios())
    }
    
}


extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}


struct Position: Hashable {
    let row: Int
    let col: Int
}


struct NumberParser {
    
    let engine : [String]
    var parsingCursor = Position(row:0, col:0)
    var digitsOfCurrentNumber = ""
    var foundSymbolCloseToCurrentNumber = false
    var starsCloseToCurrentNumber: Set<(Position)> = []
    var validNumbers: [Int] = []
    var numbersCloseToStars: [Position:[Int]] = [:]
    
    init(_ schematic: [String]) {
        engine = schematic
    }
    
    mutating func nextNumber() -> (Int?, Bool) {
        guard parsingCursor.row < engine.count else {
            return (nil, false)
        }
        if parsingCursor.col >= engine[parsingCursor.row].count || !engine[parsingCursor.row][parsingCursor.col].isNumber {
            return parsedNonDigitCharacter()
        }
        return parsedDigit()
    }
        
    fileprivate mutating func parsedNonDigitCharacter() -> (Int?, Bool) {
        moveParsingCursor()
        if !digitsOfCurrentNumber.isEmpty {
            return finishedParsingNumber()
        }
        return nextNumber()
    }

    fileprivate mutating func finishedParsingNumber() -> (Int?, Bool) {
        let value = Int(digitsOfCurrentNumber)
        let valid = foundSymbolCloseToCurrentNumber
        if valid {
            validNumbers.append(value ?? 0)
            updateNearbyStars(value)
        }
        prepareForNextNumber()
        return (value, valid)
    }
        
    fileprivate mutating func updateNearbyStars(_ value: Int?) {
        for star in starsCloseToCurrentNumber {
            if var numbers = numbersCloseToStars[star] {
                numbers.append(value ?? 0)
                numbersCloseToStars[star] = numbers
            } else {
                numbersCloseToStars[star] = [value ?? 0]
            }
        }
    }
    
    fileprivate mutating func parsedDigit() -> (Int?, Bool) {
        digitsOfCurrentNumber.append(engine[parsingCursor.row][parsingCursor.col])
        foundSymbolCloseToCurrentNumber = foundSymbolCloseToCurrentNumber || isSymbolNearby()
        moveParsingCursor()
        return nextNumber()
    }

    fileprivate mutating func moveParsingCursor() {
        if parsingCursor.row >= engine.count {
            return
        }
        if parsingCursor.col >= engine[parsingCursor.row].count {
            parsingCursor = Position(row: parsingCursor.row+1, col: 0)
            return
        }
        parsingCursor = Position(row: parsingCursor.row, col: parsingCursor.col+1)
    }
    
    fileprivate mutating func isSymbolNearby() -> Bool {
        for r in parsingCursor.row-1...parsingCursor.row+1 {
            for c in parsingCursor.col-1...parsingCursor.col+1 {
                if isSymbol(at: Position(row: r, col: c)) {
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate mutating func isSymbol(at position: Position) -> Bool {
        if position.row<0 || position.row >= engine.count {
            return false
        }
        if position.col<0 || position.col >= engine[position.row].count {
            return false
        }
        if engine[position.row][position.col].isNumber {
            return false
        }
        if engine[position.row][position.col] == "." {
            return false
        }
        if engine[position.row][position.col] == "*"  {
            starsCloseToCurrentNumber.insert(position)
        }
        return true
    }
    
    fileprivate mutating func prepareForNextNumber() {
        digitsOfCurrentNumber = ""
        foundSymbolCloseToCurrentNumber = false
        starsCloseToCurrentNumber.removeAll()
    }
    
    func sumOfGearRatios() -> Int {
        var sum = 0
        for (_, numbers) in numbersCloseToStars {
            if numbers.count == 2 {
                sum += numbers[0]*numbers[1]
            }
        }
        return sum
    }
   
    func sumValidNumbers() -> Int {
        return validNumbers.reduce(0, +)
    }

    
}
