//
//  day09.swift
//  aoc23
//
//  Created by Oliver Hofmann on 09.12.23.
//

import Foundation




public struct Day09Solution : DailySolution {

    enum AoCError: Error {
        case runtimeError(String)
    }

    func solvePart1(puzzle: [String]) -> String {
        let histories = parse(puzzle)
        for history in histories { history.expandToRight() }
        let result = histories.map { $0.numbers.last! }.reduce(0, +)
        return String(result)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        let histories = parse(puzzle)
        for history in histories { history.expandToLeft() }
        let result = histories.map { $0.numbers.first! }.reduce(0, +)
        return String(result)
    }
    
    func parse(_ lines: [String]) -> [History] {
        return lines.compactMap { History(line: $0) }
    }
    
    class History {
        var numbers = [Int]()
        let pre: History?
        
        init?(line: String, parent: History? = nil ) {
            if line.isEmpty {
                return nil
            }
            numbers = line.components(separatedBy: " ").compactMap { Int($0) }
            pre = parent
        }
        
        init(_ nums: [Int], parent: History? = nil) {
            numbers = nums
            pre = parent
        }
        
        func followUp() -> History {
            let newNumbers = numbers.dropFirst().enumerated().map { index, number in return number - numbers[index] }
            return History(newNumbers, parent: self)
        }
        
        func isEndOfHistory() -> Bool {
            numbers.reduce(true, {a, num in a && (num == 0)})
        }
        
        func expandToRight() {
            if !isEndOfHistory() {
                followUp().expandToRight()
            }
            if let parent = pre {
                let newValue = (parent.numbers.last ?? 0) + (numbers.last ?? 0)
                parent.numbers.append(newValue)
            }
        }

        func expandToLeft() {
            if !isEndOfHistory() {
                followUp().expandToLeft()
            } 
            if let parent = pre {
                let newValue = (parent.numbers.first ?? 0) - (numbers.first ?? 0)
                parent.numbers.insert(newValue, at: 0)
            }
        }
    }
}


