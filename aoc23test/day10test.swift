//
//  day10test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 10.12.23.
//

import XCTest

final class day10test: XCTestCase {

    let testPuzzle = [
        "..F7.",
        ".FJ|.",
        "SJ.L7",
        "|F--J",
        "LJ...",
        "",
    ]
    
    
    func testSolvePart1() throws {
        let solution = Day10Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("8", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day10Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
    
    func testParse() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle)
        XCTAssertEqual("F", nodes[Day10Solution.Position(row:0, col: 2)])
    }
    
    func testEdges() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle)
        let edges = solution.findEdges(nodes)
        XCTAssertEqual(2, edges[Day10Solution.Position(row:0, col: 2)]?.count ?? 0)
    }

    func testStart() throws {
        let solution = Day10Solution()
        let nodes = solution.parse(testPuzzle)
        let start = solution.startPosition(nodes)
        XCTAssertEqual(Day10Solution.Position(row:2, col: 0), start!)
    }

    

}
