//
//  XCOpenTool.swift
//  XCOpenKit
//
//  Created by Yutaro Muta on 2018/04/14.
//

import Foundation
import Utility
import Basic
import POSIX
import PathKit

public struct XCOpenTool {
    let parser: ArgumentParser
    let options: Options

    public init(arguments: [String]) {
        parser = ArgumentParser(commandName: "xcopen", usage: "[options] subcommand [options]", overview: "Open file of .xcodeproj, .xcworkspace or .playground")

        let binder = ArgumentBinder<Options>()
        binder.bind(parser: parser) { $0.subcommand = Options.Command(rawValue: $1) }
        binder.bind(option: parser.add(option: "--version", kind: Bool.self)) { options, _ in options.subcommand = Options.Command.version }
        binder.bind(option: parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")) { $0.verbose = $1 }

        let open = parser.add(subparser: "open", overview: "Open file of .xcodeproj, .xcworkspace or .playground")
        binder.bind(parser: open) { $0.subcommand = Options.Command(rawValue: $1) }
        binder.bind(positional: open.add(positional: "fileName", kind: String.self, usage: "Open file name like a Xxx.xcodeproj")) { $0.fileName = $1 }
        binder.bind(option: open.add(option: "--path", shortName: "-p", kind: String.self, usage: "Explore path. Defaults is current")) { $0.path = Path($1) }
        binder.bind(option: open.add(option: "--openFinder", shortName: "-o", kind: Bool.self, usage: "Whether to open in Xcode or Finder")) { $0.isOpenFinder = $1 }

        let list = parser.add(subparser: "list", overview: "Explore files of .xcodeproj, .xcworkspace or .playground")
        binder.bind(parser: list) { $0.subcommand = Options.Command.init(rawValue: $1) }
        binder.bind(option: list.add(option: "--path", shortName: "-p", kind: String.self, usage: "Explore path. Defaults is current")) { $0.path = Path($1) }

        do {
            let result = try parser.parse(arguments)
            var options = Options()
            try binder.fill(parseResult: result, into: &options)
            self.options = options
        } catch {
            handle(error: error)
            POSIX.exit(1)
        }
    }

    public func run() throws {
        guard let subcommand = options.subcommand else {
            throw XCOpenError.failedRun(description: "Nomatch subcommands")
        }

        switch subcommand {
        case .open:
            let command = OpenTool()
            try command.run(fileName: options.fileName!, path: options.path, isOpenFinder: options.isOpenFinder, verbose: options.verbose)
        case .list:
            let command = ListTool()
            _ = command.run(path: options.path, verbose: options.verbose)
        case .version:
            print(XCOpenKit.version)
        }
    }
}

struct Options {
    var verbose = false
    var subcommand: Command?
    var path: Path?
    var fileName: String?
    var isOpenFinder: Bool = false

    enum Command: String, CustomStringConvertible {
        case open = "open"
        case list = "list"
        case version = "version"

        var description: String {
            return self.rawValue
        }
    }
}
