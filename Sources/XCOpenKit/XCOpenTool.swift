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

public struct XCOpenTool {
    let parser: ArgumentParser
    let options: Options

    public init(arguments: [String]) {
        parser = ArgumentParser(commandName: "xcopen", usage: "[options] subcommand [options]", overview: "Open file of .xcodeproj or .xcworkspace")

        let binder = ArgumentBinder<Options>()
        binder.bind(parser: parser) { $0.subcommand = $1 }
        binder.bind(option: parser.add(option: "--version", kind: Bool.self)) { (options, _) in options.subcommand = "version" }
        binder.bind(option: parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")) { $0.isVerbose = $1 }

        let open = parser.add(subparser: "open", overview: "Open file of .xcodeproj or .xcworkspace")
        binder.bind(parser: open) { $0.subcommand = $1 }
        binder.bind(positional: open.add(positional: "source", kind: String.self), to: { $0.source = $1 })

        let list = parser.add(subparser: "list", overview: "Show files of .xcodeproj or .xcworkspace in local")
        binder.bind(parser: list) { $0.subcommand = $1 }

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

    public func run() {
        switch options.subcommand {
        case "list":
            print(options.source)
            break
        case "version":
            print(XCOpenKit.version)
        default:
            parser.printUsage(on: stdoutStream)
        }
    }
}

struct Options {
    var isVerbose = false
    var subcommand = ""
//    public var subcommand: Command?
    var source = ""

    enum Command: String, CustomStringConvertible {
        case list = "list"

        var description: String {
            return self.rawValue
        }
    }
}
