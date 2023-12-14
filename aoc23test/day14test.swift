//
//  day14test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 13.12.23.
//

import XCTest

final class day14test: XCTestCase {

    let testPuzzle = [
        "O....#....",
        "O.OO#....#",
        ".....##...",
        "OO.#O....O",
        ".O.....O#.",
        "O.#..O.#.#",
        "..O..#O..O",
        ".......O..",
        "#....###..",
        "#OO..#....",
        "",
    ]
    
    let solution = Day14Solution()
    
    func testMapCreation() throws {
        let result = Day14Solution.Map(testPuzzle)
        XCTAssertEqual(17, result.rocks.filter { $0.movable == false }.count)
        XCTAssertEqual(18, result.rocks.filter { $0.movable == true }.count)
    }
    
    func testTiltColumn() throws {
        let field = Day14Solution.Map(testPuzzle)
        let col = field.tiltedColumn(2)
        let load = col.map{ field.loadOfRock($0)}.reduce(0, +)
        XCTAssertEqual(17, load)
    }
        
    func testLoad() throws {
        XCTAssertEqual(4, Day14Solution.Map(["OO", ".."]).load)
        XCTAssertEqual(3, Day14Solution.Map(["O.", ".O"]).load)
        XCTAssertEqual(0, Day14Solution.Map(["##", ".."]).load)
    }
    
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("136", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("64", result)
    }
}
