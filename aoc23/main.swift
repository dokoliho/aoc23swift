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


let solution = Day01Solution()
let currentPuzzle = Day01Solution.readPuzzleFrom(filename: "day01.txt")

//let currentPuzzle = ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
// let currentPuzzle = ["two1nine", "eightwothree", "abcone2threexyz", "xtwone3four", "4nineeightseven2", "zoneight234", "7pqrstsixteen"]

runWithTimeControl(title: "Teil1", data: currentPuzzle, operation: solution.solvePart1)
runWithTimeControl(title: "Teil2", data: currentPuzzle, operation: solution.solvePart2)

