//
//  day15test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 15.12.23.
//

import XCTest

final class day15test: XCTestCase {

    let testPuzzle = [
        "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7",
        "",
    ]
    
    let solution = Day15Solution()
    
    func testHash() throws {
        let result = solution.hash("HASH")
        XCTAssertEqual(52, result)
        
    }
  
    func testSumHashSequence() throws {
        let result = solution.sumHashSequence("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
        XCTAssertEqual(1320, result)
    }
    
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("1320", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("145", result)
    }
}
