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
        parser = ArgumentParser(commandName: "xcopen", usage: "[options] subcommand [options]", overview: "Open file of .xcodeproj or .xcworkspace")

        let binder = ArgumentBinder<Options>()
        binder.bind(parser: parser) { $0.subcommand = Options.Command(rawValue: $1) }
        binder.bind(option: parser.add(option: "--version", kind: Bool.self)) { (options, _) in options.subcommand = Options.Command.version }
        binder.bind(option: parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")) { $0.verbose = $1 }

        let open = parser.add(subparser: "open", overview: "Open file of .xcodeproj or .xcworkspace")
        binder.bind(parser: open) { $0.subcommand = Options.Command(rawValue: $1) }
        binder.bind(positional: open.add(positional: "path", kind: String.self), to: { $0.path = Path($1) })

        let list = parser.add(subparser: "list", overview: "Show files of .xcodeproj or .xcworkspace in local")
        binder.bind(parser: list) { $0.subcommand = Options.Command.init(rawValue: $1) }
        binder.bind(option: list.add(option: "--path", shortName: "-p", kind: String.self, usage: "Explore path. Defaults is current"), to: { $0.path = Path($1) })

        do {
            let result = try parser.parse(arguments)
            var options = Options()
            binder.fill(result, into: &options)
            self.options = options
        } catch {
            handle(error: error)
            POSIX.exit(1)
        }
    }

    public func run() throws {
        guard let subcommand = options.subcommand else {
            throw XCOpenError.failedRun(description: "")
        }

        switch subcommand {
        case .open:
            parser.printUsage(on: stdoutStream)
        case .list:
            let command = ListTool()
            _ = try command.run(path: options.path, verbose: options.verbose)
        case .version:
            print(XCOpenKit.version)
        }
    }
}

struct Options {
    var verbose = false
    var subcommand: Command?
    var path: Path?

    enum Command: String, CustomStringConvertible {
        case open = "open"
        case list = "list"
        case version = "version"

        var description: String {
            return self.rawValue
        }
    }
}
