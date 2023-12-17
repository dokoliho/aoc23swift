//
//  day17test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 17.12.23.
//

import XCTest

final class day17test: XCTestCase {

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
    
    let solution = Day17Solution()
    
        
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
}
