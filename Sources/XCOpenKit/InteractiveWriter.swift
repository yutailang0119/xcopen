//
//  InteractiveWriter.swift
//  Basic
//
//  Created by Yutaro Muta on 2018/04/14.
//

import Basic

final class InteractiveWriter {
    static let stdout = InteractiveWriter(stream: stdoutStream)
    static let stderr = InteractiveWriter(stream: stderrStream)

    private let terminal: TerminalController?
    private let stream: OutputByteStream

    init(stream: OutputByteStream) {
        self.terminal = (stream as? LocalFileOutputByteStream).flatMap(TerminalController.init(stream:))
        self.stream = stream
    }

    func write(_ string: String, inColor color: TerminalController.Color = .noColor, bold: Bool = false) {
        if let terminal = terminal {
            terminal.write(string, inColor: color, bold: bold)
        } else {
            stream <<< string
            stream.flush()
        }
    }
}

