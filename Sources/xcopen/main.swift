import XCOpenKit

do {
    let parser = OptionParser(arguments: Array(CommandLine.arguments.dropFirst()))
    let options = parser.options
    if options.isPrintVersion {
        print("0.0.1")
    }
}
