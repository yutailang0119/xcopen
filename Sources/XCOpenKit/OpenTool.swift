//
//  OpenTool.swift
//  XCOpenKit
//
//  Created by Yutaro Muta on 2018/04/29.
//

import Foundation
import PathKit

struct OpenTool {
    func run(fileName: String, path: Path?, verbose: Bool = false) throws {
        let path: Path = path ?? Path.current

        print("search of \"\(path.description)\"...")

        let all = try path.recursiveChildren()
        let packages = all.flatMap { $0.glob(fileName) }

        switch packages.count {
        case 0:
            throw XCOpenError.failedRun(description: "Nomatch fileName: \(fileName)")
        case 1:
            open(of: packages[0])
        default:
            let selectedPackage = try selectPackage(from: packages)
            open(of: selectedPackage)
        }
    }

    private func open(of path: Path) {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", "open \(path.description)"]
        process.launch()
        process.waitUntilExit()
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
