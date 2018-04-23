import XCOpenKit

do {
    let arguments = Array(CommandLine.arguments.dropFirst())
    let tool = XCOpenTool(arguments: arguments)
    try tool.run()
} catch {
    handle(error: error)
}
