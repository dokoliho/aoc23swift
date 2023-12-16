//
//  day16test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 16.12.23.
//

import XCTest

final class day16test: XCTestCase {
    
    let testPuzzle = [
        ".|...\\....",
        "|.-.\\.....",
        ".....|-...",
        "........|.",
        "..........",
        ".........\\",
        "..../.\\\\..",
        ".-.-/..|..",
        ".|....-|.\\",
        "..//.|....",
        "",
    ]
    
    let solution = Day16Solution()
    
    
    func testPanelCreation() throws {
        let result = solution.createPanel(lines: testPuzzle)
        
        XCTAssertEqual(23, result.cells.count)
        
    }
    
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("46", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("51", result)
    }
}
