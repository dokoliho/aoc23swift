//
//  day09test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 09.12.23.
//

import XCTest

final class day09test: XCTestCase {
    
    
    let testPuzzle = [
        "0 3 6 9 12 15",
        "1 3 6 10 15 21",
        "10 13 16 21 30 45",
        "",
    ]
    
    func testHistory() throws {
        let solution = Day09Solution()
        let histories = solution.parse(testPuzzle)
        XCTAssertEqual(3, histories.count)
        XCTAssertEqual(10, histories[2].numbers[0])
        XCTAssertTrue(histories[0].pre == nil)
    }
    
    func testFollowUp() throws {
        let solution = Day09Solution()
        let histories = solution.parse(testPuzzle)
        
        // expected: [3, 3, 3, 3, 3]
        let result = histories[0].followUp()
        
        XCTAssertEqual(5, result.numbers.count)
        XCTAssertTrue(result.pre === histories[0])
        XCTAssertEqual([3, 3, 3, 3, 3], result.numbers)
    }

    
    func testEndOfHistory() throws {
        let solution = Day09Solution()
        let histories = solution.parse(testPuzzle)
        
        let step1 = histories[0].followUp()
        let step2 = step1.followUp()

        XCTAssertFalse(histories[0].isEndOfHistory())
        XCTAssertFalse(step1.isEndOfHistory())
        XCTAssertTrue(step2.isEndOfHistory())
    }
    
    
    func testExpandToRight() throws {
        let solution = Day09Solution()
        let histories = solution.parse(testPuzzle)
        
        histories[0].expandToRight()

        XCTAssertEqual(18, histories[0].numbers.last!)
    }


    
    func testSolvePart1() throws {
        let solution = Day09Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("114", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day09Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("2", result)
    }
}
