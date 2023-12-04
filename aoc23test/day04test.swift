//
//  day04test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 04.12.23.
//

import XCTest

final class day04test: XCTestCase {
    
    let currentPuzzle = [
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
        "",
        ]
    

    func testCardCreation() throws {
        for (i, line) in currentPuzzle.enumerated() {
            if let card = try? Card(line: line) {
                XCTAssertEqual(i+1, card.id)
                XCTAssertEqual(5, card.winningNumbers.count)
                XCTAssertEqual(8, card.ownedNumbers.count)
            }
        }
    }
    
    func testCountWinningNumbers() throws {

        for (c, w) in [(1, 4), (2, 2), (3, 2), (4, 1), (5, 0), (6, 0)] {
            if let card = try? Card(line: currentPuzzle[c-1]) {
                XCTAssertEqual(w, card.countWinningNumbers)
            } else {
                XCTFail("Card \(c) not created.")
            }
        }
    }
    
    func testPoints() throws {

        for (c, w) in [(1, 8), (2, 2), (3, 2), (4, 1), (5, 0), (6, 0)] {
            if let card = try? Card(line: currentPuzzle[c-1]) {
                XCTAssertEqual(w, card.points)
            } else {
                XCTFail("Card \(c) not created.")
            }
        }
    }

    func testSolvePart1() throws {
        let solution = Day04Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("13", result)
    }

    func testSolvePart2() throws {
        let solution = Day04Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("30", result)
    }

    
}
