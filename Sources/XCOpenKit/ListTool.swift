//
//  ListTool.swift
//  Basic
//
//  Created by Yutaro Muta on 2018/04/24.
//

import Foundation
import PathKit
import Hydra
import Basic
import Utility
import ProgressSpinnerKit

struct Packages {
    let xcodeprojs: [Path]
    let xcworkspaces: [Path]
    let playgrounds: [Path]

    var all: [Path] {
        return xcodeprojs + xcworkspaces + playgrounds
    }
}

struct ListTool {

    func run(path: Path?, verbose: Bool = false) {
        let path: Path = path ?? Path.current

        let startDate = Date()

        let progressSpinner = createProgressSpinner(forStream: stdoutStream, header: " Loading:")

        async(in: .background) {
            do {
                let paths: [Path] = try await(self.recursiveChildren(from: path))

                let (xcodeprojs, xcworkspaces, playgrounds) = try await(
                    Promise<([Path], [Path], [Path])>.zip(
                        in: .background,
                        a: self.glob("*.xcodeproj", from: paths),
                        b: self.glob("*.xcworkspace", from: paths),
                        c: self.glob("*.playground", from: paths)
                        )
                        .always {
                            progressSpinner.stop()
                    }
                )
                let packages = Packages(xcodeprojs: xcodeprojs, xcworkspaces: xcworkspaces, playgrounds: playgrounds)

                let writer = InteractiveWriter.stdout
                packages.all.forEach { package in
                    writer.write(package.lastComponent, inColor: .cyan, bold: true)
                    writer.write(" \(package.description)\n")
                }
                writer.write("xcodeprojs: \(packages.xcodeprojs.count), xcworkspaces: \(packages.xcworkspaces.count), playgrounds: \(packages.playgrounds.count)\n")
                let processTimeInterval = Date().timeIntervalSince(startDate)
                writer.write("\(String(round(processTimeInterval * 100) / 100 ))seconds", inColor: .yellow, bold: true)
                exit(0)

            } catch {
                print(error)
            }
        }

        progressSpinner.start()
        pause()
    }

    private func recursiveChildren(from path: Path, in context: Context? = nil) -> Promise<[Path]> {
        return Promise<[Path]>.init(in: context, token: nil) { resolve, reject, _ in
            do {
                resolve(try path.recursiveChildren())
            } catch {
                reject(error)
            }
        }
    }

    private func glob(_ pattern: String, from paths: [Path], in context: Context? = nil) -> Promise<[Path]> {
        return Promise<[Path]>(in: context, token: nil) { resolve, _, _ in
            let result = paths.flatMap { $0.glob(pattern) }
            resolve(result)
        }
    }
}
