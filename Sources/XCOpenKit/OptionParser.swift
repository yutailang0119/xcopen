//
//  OptionParser.swift
//  XCOpenKit
//
//  Created by Yutaro Muta on 2018/04/14.
//

import Utility
import Basic
import POSIX

public struct OptionParser {
    public let options: Options
    private let parser: ArgumentParser

    public init(arguments: [String]) {
        parser = ArgumentParser(commandName: "xcopen", usage: "xcopen [options]", overview: "Open file of .xcodeproj or .xcworkspace")

        let binder = ArgumentBinder<Options>()
        binder.bind(option: parser.add(option: "--version", kind: Bool.self)) { $0.isPrintVersion = $1 }
        binder.bind(option: parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")) { $0.verbose = $1 }

        do {
            let result = try parser.parse(arguments)
            var options = Options()
            binder.fill(result, into: &options)
            self.options = options
        } catch {
            print(error)
            POSIX.exit(1)
        }
    }

    func printUsage(on stream: OutputByteStream) {
        parser.printUsage(on: stream)
    }
}

public struct Options {
    public var isPrintVersion: Bool = false
    public var verbose = false
}
