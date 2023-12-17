//
//  day17test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 17.12.23.
//

import XCTest

final class day17test: XCTestCase {

    let testPuzzle = [
        "2413432311323",
        "3215453535623",
        "3255245654254",
        "3446585845452",
        "4546657867536",
        "1438598798454",
        "4457876987766",
        "3637877979653",
        "4654967986887",
        "4564679986453",
        "1224686865563",
        "2546548887735",
        "4322674655533",
        "",
    ]
    
    let solution = Day17Solution()
    
    
    func testCreatePanel() throws {
        let panel = solution.createPanel(lines: testPuzzle)
        XCTAssertEqual(13, panel.height)
        XCTAssertEqual(13, panel.width)
        XCTAssertEqual(2, panel[0, 0]!)
    }
    
        
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("102", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
}
