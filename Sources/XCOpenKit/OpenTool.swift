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

        if packages.isEmpty {
            throw XCOpenError.failedRun(description: "Nomatch fileName: \(fileName)")
        }
        open(of: packages[0])
    }

    private func open(of path: Path) {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", "open \(path.description)"]
        process.launch()
        process.waitUntilExit()
    }

}
