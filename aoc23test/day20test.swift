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
    
    
    func testComplexPuzzle() throws {
        let map = solution.parse(lines: testPuzzle2)
        MachineModule.reset()
        var _ = MachineModule.push(map: map)
        XCTAssertEqual(4, MachineModule.countLowPulses)
        XCTAssertEqual(4, MachineModule.countHighPulses)
        MachineModule.reset()
        var _ = MachineModule.push(map: map)
        XCTAssertEqual(4, MachineModule.countLowPulses)
        XCTAssertEqual(2, MachineModule.countHighPulses)
        MachineModule.reset()
        var _ = MachineModule.push(map: map)
        XCTAssertEqual(5, MachineModule.countLowPulses)
        XCTAssertEqual(3, MachineModule.countHighPulses)
        MachineModule.reset()
        var _ = MachineModule.push(map: map)
        XCTAssertEqual(4, MachineModule.countLowPulses)
        XCTAssertEqual(2, MachineModule.countHighPulses)
    }
    
    
    func testSolvePart1() throws {
        var result = solution.solvePart1(puzzle: testPuzzle1)
        XCTAssertEqual("32000000", result)
        result = solution.solvePart1(puzzle: testPuzzle2)
        XCTAssertEqual("11687500", result)

    }
    
    
}
