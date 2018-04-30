//
//  Misc.swift
//  XCOpenKit
//
//  Created by Yutaro Muta on 2018/04/14.
//

import Utility
import Basic

public let version = Version(0, 0, 1,
                             prereleaseIdentifiers: [],
                             buildMetadataIdentifiers: [])

public func handle(error: Error) {
    switch error {
    case ArgumentParserError.expectedArguments(let parser, _):
        print(error: error)
        parser.printUsage(on: stderrStream)
    default:
        print(error: error)
    }
}

private func print(error: Error) {
    let writer = InteractiveWriter.stderr
    writer.write("error: ", inColor: .red, bold: true)
    writer.write("\(error)")
    writer.write("\n")
}
