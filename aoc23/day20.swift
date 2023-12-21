//
//  day20.swift
//  aoc23
//
//  Created by Oliver Hofmann on 20.12.23.
//

import Foundation

public struct Day20Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    
    func solvePart1(puzzle: [String]) -> String {
        let map = parse(lines: puzzle)
        reset()
        while MachineModule.countPushes < 1000 {
            var _ = MachineModule.push(map: map)
        }
        return String(lowPulses * highPulses)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        let map = parse(lines: puzzle)
        reset()
        var result: Int? = nil;
        while result == nil {
            result = MachineModule.push(map: map)
        }
        return String(result!)
   }
    
    
    func parse(lines: [String]) -> [String: MachineModule] {
        var result = [String: MachineModule]()
        for line in lines.filter({ !$0.isEmpty }) {
            //      "%a -> inv, con",
            let search = /^(?<type>[%, &]?)(?<name>[a-z]+) -> (?<connections>.*)$/
            if let match = try? search.wholeMatch(in: line) {
                let name = String(match.name)
                switch String(match.type) {
                case "":
                    result[name] = Broadcaster(id: name, connectString: String(match.connections))
                case "&":
                    result[name] = Conjunction(id: name, connectString: String(match.connections))
                case "%":
                    result[name] = FlipFlop(id: name, connectString: String(match.connections))
                default:
                    print("Illegal type" )
                }
            }
            else {
                print("Parsing Error: " + line)
            }
        }
        for module in result.values {
            module.setConnections(map: result)
        }
        return result
    }
    
    func reset() {
        MachineModule.reset()
    }
    
    var lowPulses: Int {
        return MachineModule.countLowPulses
    }
    
    var highPulses: Int {
        return MachineModule.countHighPulses
    }
    
}


enum ModuleState: Int {
    case low = 0
    case high
}

class MachineModule {

    static var countLowPulses: Int = 0
    static var countHighPulses: Int = 0
    static var pipeline: [Notification] = []
    static var countPushes: Int = 0

    static let sink = MachineModule(id: "SINK", connectString: "")
    
    static var predOfRX: String = ""
    
    static func reset() {
        countLowPulses = 0
        countHighPulses = 0
        countPushes = 0
        pipeline = []
    }
    
    
    static func push(map: [String: MachineModule]) -> Int? {
        // print ("********** PUSH ************")
        MachineModule.countPushes += 1
        if let broadcaster = map["broadcaster"] {
            MachineModule.pipeline.append(Notification(sender: "BUTTON", receiver: broadcaster, state: ModuleState.low ))
            while !MachineModule.pipeline.isEmpty {
                let currentTrigger = MachineModule.pipeline.removeFirst()
                if currentTrigger.state == ModuleState.low {
                    MachineModule.countLowPulses += 1
                } else {
                    MachineModule.countHighPulses += 1
                }
                if let result = currentTrigger.receiver.gotTriggered(from: currentTrigger.sender, with: currentTrigger.state) {
                    return result
                }
            }
        } else {
            print("No broadcaster")
        }
        return nil
    }
    
    
    let name: String
    let connections: [String]
    var connectedTo: [MachineModule]

    
    init(id: String, connectString: String) {
        name = id
        connections = connectString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        connectedTo = []
    }


    func gotTriggered(from sender: String, with state : ModuleState) -> Int? {
        // print(sender + " -" + (state==ModuleState.low ? "low" : "high") + "-> " + name)
        return nil
    }
    
    
    func gotConnected(from sender: String) {}
    
    func setConnections(map: [String: MachineModule]) {
        for name in self.connections {
            if let module = map[name] {
                self.connectedTo.append(module)
                module.gotConnected(from: self.name)
            } else {
                self.connectedTo.append(MachineModule.sink)
            }
            if name == "rx" {
                MachineModule.predOfRX = self.name
            }
        }
    }
    
    func notifyAll(with state: ModuleState) {
        for module in connectedTo {
            MachineModule.pipeline.append(Notification(sender: name, receiver: module, state: state ))
        }
    }
}

struct Notification {
    let sender: String
    let receiver: MachineModule
    let state: ModuleState
}


class Broadcaster : MachineModule {

    override func gotTriggered(from sender: String, with state : ModuleState) -> Int? {
        var _ = super.gotTriggered(from: sender, with: state)
        notifyAll(with: state)
        return nil
    }
        
}


class FlipFlop : MachineModule {

    var isOn: Bool = false
    
    override func gotTriggered(from sender: String, with state : ModuleState) -> Int?  {
        var _ = super.gotTriggered(from: sender, with: state)
        if state == ModuleState.low {
            isOn = !isOn
            notifyAll(with: isOn ? ModuleState.high : ModuleState.low)
        }
        return nil
    }
}


class Conjunction : MachineModule {

    var storedStates: [String: ModuleState] = [:]
    var highCycles: [String: [Int]] = [:]

    override func gotConnected(from sender: String) {
        storedStates[sender] = ModuleState.low
        highCycles[sender] = []
    }
    
    override func gotTriggered(from sender: String, with state : ModuleState) -> Int?  {
        var _ = super.gotTriggered(from: sender, with: state)
        storedStates[sender] = state
        let allHigh = storedStates.values.map{ $0 == ModuleState.high}.reduce(true, { a, c in a && c })
        notifyAll(with: allHigh ? ModuleState.low : ModuleState.high)
        
        // part 2
        // rx has only 1 input
        // this input is a conjunction, i.e.: low will be emmited when all inputs high
        // code below checks, when inputs become high
        // After 3 repeating cycles each: guess - no offset, result is kgV of single cycle lengths
        if name == MachineModule.predOfRX {
            if state == ModuleState.high {
                highCycles[sender]?.append(MachineModule.countPushes)
                if highCycles.values.map({ $0.count}).reduce(true, {a, c in a && c>3}) {
                    var kgvInput = [Int]()
                    for s in highCycles.keys {
                        let cycles = zip(highCycles[s]!, highCycles[s]!.dropFirst()).map { $0.1 - $0.0 }
                        print(s + ": " + String(highCycles[s]!.first!) + ":" + cycles.map{String($0)}.joined(separator: "-"))
                        kgvInput.append(highCycles[s]!.first!)
                    }
                    let result = kgvInput.reduce(1, {a, c in Day08Solution.kgV(v1: a, v2: c)})
                    return result
                }
            }
        }
        return nil
    }
        
}

