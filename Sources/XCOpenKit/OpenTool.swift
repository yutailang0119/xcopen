//
//  OpenTool.swift
//  XCOpenKit
//
//  Created by Yutaro Muta on 2018/04/29.
//

import Foundation
import PathKit

struct OpenTool {
    func run(fileName: String, path: Path?, isOpenFinder: Bool = false, verbose: Bool = false) throws {
        let path: Path = path ?? Path.current

        print("Searching of \"\(fileName)\" from \(path.description)")

        let all = try path.recursiveChildren()
        let packages = all.filter { $0.lastComponent == fileName }

        switch packages.count {
        case 0:
            throw XCOpenError.failedRun(description: "Nomatch fileName: \(fileName)")
        case 1:
            try open(of: packages[0], isOpenFinder: isOpenFinder)
        default:
            let selectedPackage = try selectPackage(from: packages)
            try open(of: selectedPackage, isOpenFinder: isOpenFinder)
        }
    }

    private func open(of path: Path, isOpenFinder: Bool) throws {
        let path = isOpenFinder ? path.parent() : path

        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", "open \(path.description)"]
        if #available(OSX 10.13, *) {
            try process.run()
        } else {
            process.launch()
        }
        process.waitUntilExit()
        print("Opened \"\(path.lastComponent)\"")
    }

    private func selectPackage(from packages: [Path]) throws -> Path {
        typealias Inquiry = (sentence: String, choices: [String])

        let inquiry: Inquiry = packages.enumerated()
            .reduce(into: Inquiry(sentence: "Which do you want to open? Please select index\n", choices: [])) { result, value in
                result.sentence += "[\(value.offset)]: \(value.element.description)\n"
                result.choices.append(String(value.offset))
        }

        let question = Question()
        let selected = question.ask(inquiry.sentence, answers: inquiry.choices)

        guard let index = Int(selected) else {
            throw XCOpenError.failedRun(description: "Nomatch selected")
        }

        return packages[index]
    }

}
