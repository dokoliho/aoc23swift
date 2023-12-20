//
//  day20test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 20.12.23.
//

import XCTest

final class day20test: XCTestCase {

    let testPuzzle1 = [
        "broadcaster -> a, b, c",
        "%a -> b",
        "%b -> c",
        "%c -> inv",
        "&inv -> a",
        "",
    ]
    
    let testPuzzle2 = [
        "broadcaster -> a",
        "%a -> inv, con",
        "&inv -> b",
        "%b -> con",
        "&con -> output",
        "",
    ]
        
        
        
    let solution = Day20Solution()
    

    func testParse() throws {
        let result = solution.parse(lines: testPuzzle1)
        XCTAssertEqual(5, result.count)
    }

    
    
    func testSolvePart1() throws {
        var result = solution.solvePart1(puzzle: testPuzzle1)
        XCTAssertEqual("32000000", result)
        result = solution.solvePart1(puzzle: testPuzzle2)
        XCTAssertEqual("11687500", result)

    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle1)
        XCTAssertEqual("", result)
    }
    
}
