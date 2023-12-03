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


let solution = Day03Solution()
let currentPuzzle = Day03Solution.readPuzzleFrom(filename: "day03.txt")



runWithTimeControl(title: "Teil1", data: currentPuzzle, operation: solution.solvePart1)
runWithTimeControl(title: "Teil2", data: currentPuzzle, operation: solution.solvePart2)

