//
//  main.swift
//  aoc23
//
//  Created by Oliver Hofmann on 23.11.23.
//

import Foundation

func runWithTimeControl(title: String, data: [String], operation: ([String])->String) {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = operation(data)
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("\(title): \(result) (\(timeElapsed) s.)")
}

func readPuzzleFrom(filename: String) -> [String] {
    do {
        let file = try String(contentsOfFile: filename)
        let text: [String] = file.components(separatedBy: "\n")
        return text
    } catch let error {
        Swift.print("Fatal Error: \(error.localizedDescription)")
    }
    return []
}



let currentPuzzle = readPuzzleFrom(filename: "day19.txt")
let solution = Day19Solution()


runWithTimeControl(title: "Teil1", data: currentPuzzle, operation: solution.solvePart1)
runWithTimeControl(title: "Teil2", data: currentPuzzle, operation: solution.solvePart2)

