//
//  ListTool.swift
//  Basic
//
//  Created by Yutaro Muta on 2018/04/24.
//

import Foundation
import PathKit

struct ListTool {
    func run(path: Path?, verbose: Bool = false) throws -> [Path] {
        let path: Path = path ?? Path.current

        print("search of \"\(path.description)\"...")

        let all = try path.recursiveChildren()
        let packages = all.flatMap { $0.glob("*.xcodeproj") + $0.glob("*xcworkspace") + $0.glob("*.playground") }

        let writer = InteractiveWriter.stdout
        packages.forEach { package in
            writer.write(package.lastComponent, inColor: .cyan, bold: true)
            writer.write(" \(package.description)\n")
        }

        return packages
    }
}
