//
//  day21test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 21.12.23.
//

import XCTest

final class day21test: XCTestCase {

    let testPuzzle = [
        "...........",
        ".....###.#.",
        ".###.##..#.",
        "..#.#...#..",
        "....#.#....",
        ".##..S####.",
        ".##..#...#.",
        ".......##..",
        ".##.#.####.",
        ".##..##.##.",
        "...........",
        "",
    ]
    
    let solution = Day21Solution()
    
    
    func testSteps2() throws {
        for (count, steps) in [(16, 6), (50, 10), (1594, 50), (6536, 100), (167004, 500), (668697, 1000), (16733044, 5000)] {
            var panel = Day21Solution.Panel()
            let start = panel.parse(lines: testPuzzle)
            panel.flagPart2 = true
            var _ = panel.steps(toGo: steps, activePositions: [start])
            let indices: [Int] = Array(0...steps).filter{ $0 % 2 == steps % 2}
            let sum = indices.map { panel.reached[$0]!.count }.reduce(0, +)
            XCTAssertEqual(count, sum)
        }
    }
    
    
    func testSteps1() throws {
        for (count, steps) in [(2, 1), (4, 2), (6, 3), (16, 6)] {
            var panel = Day21Solution.Panel()
            let start = panel.parse(lines: testPuzzle)
            var _ = panel.steps(toGo: steps, activePositions: [start])
            let indices: [Int] = Array(0...steps).filter{ $0 % 2 == steps % 2}
            let sum = indices.map { panel.reached[$0]!.count }.reduce(0, +)
            XCTAssertEqual(count, sum)
        }
    }
    
    
    func testSolvePart1() throws {
        // let result = solution.solvePart1(puzzle: testPuzzle)
        // XCTAssertEqual("", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
}

