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


let solution = Day02Solution()
let currentPuzzle = Day02Solution.readPuzzleFrom(filename: "tim02.txt")



runWithTimeControl(title: "Teil1", data: currentPuzzle, operation: solution.solvePart1)
runWithTimeControl(title: "Teil2", data: currentPuzzle, operation: solution.solvePart2)

