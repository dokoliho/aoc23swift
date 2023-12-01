//
//  DailySolution.swift
//  aoc23
//
//  Created by Oliver Hofmann on 23.11.23.
//

import Foundation

protocol DailySolution {
    
    // func readPuzzleFrom(filename: String) -> [String];
    func solvePart1(puzzle: [String]) -> String
    func solvePart2(puzzle: [String]) -> String
    
}

extension DailySolution {

    static func readPuzzleFrom(filename: String) -> [String] {
        do {
            let file = try String(contentsOfFile: filename)
            let text: [String] = file.components(separatedBy: "\n")
            return text
        } catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
        return []
    }
}
