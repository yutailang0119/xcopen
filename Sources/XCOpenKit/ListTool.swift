//
//  ListTool.swift
//  Basic
//
//  Created by Yutaro Muta on 2018/04/24.
//

import Foundation
import PathKit
import RxSwift
import Basic
import Utility

struct Packages {
    let xcodeprojs: [Path]
    let xcworkspaces: [Path]
    let playgrounds: [Path]

    var all: [Path] {
        return xcodeprojs + xcworkspaces + playgrounds
    }
}

struct ListTool {

    private let disposeBag = DisposeBag()

    func run(path: Path?, verbose: Bool = false) -> Single<Packages> {
        let path: Path = path ?? Path.current

        let progressBar = createProgressBar(forStream: stdoutStream, header: "Exploring from \(path.description)")
        progressBar.update(percent: 0, text: "Exploring of all")

        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        let all: Single<[Path]> = recursiveChildren(from: path)

        let packages: Single<Packages> = all
            .do(
                onSuccess: { _ in
                    progressBar.update(percent: 25, text: "Exploring of xcodeprojs, xcworkspaces and playgrounds")
            })
            .do(
                onSubscribed: {
                    Thread.sleep(forTimeInterval: 60)
            })
            .flatMap { paths in
                Observable.combineLatest(
                    self.glob("*.xcodeproj", from: paths),
                    self.glob("*.xcworkspace", from: paths),
                    self.glob("*.playground", from: paths)
                    )
                    .asSingle()
            }
            .observeOn(backgroundScheduler)
            .map { xcodeprojs, xcworkspaces, playgrounds -> Packages in
                return Packages(xcodeprojs: xcodeprojs, xcworkspaces: xcworkspaces, playgrounds: playgrounds)
        }

        packages
            .do(
                onSuccess: { _ in
                    progressBar.update(percent: 100, text: "")
                    progressBar.complete(success: true)
            })
            .subscribe(
                onSuccess: { packages in
                    let writer = InteractiveWriter.stdout
                    packages.all.forEach { package in
                        writer.write(package.lastComponent, inColor: .cyan, bold: true)
                        writer.write(" \(package.description)\n")
                    }
                    writer.write("xcodeproj: \(packages.xcodeprojs.count), xcworkspaces: \(packages.xcworkspaces.count), playgrounds: \(packages.playgrounds.count)\n")
                    exit(0)
            },
                onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)

        return packages
    }

    private func recursiveChildren(from path: Path) -> Single<[Path]> {
        let single: Single<[Path]> = Single.create { observer in
            do {
                observer(.success(try path.recursiveChildren()))
            } catch {
                observer(.error(error))
            }
            let disposable = Disposables.create()
            return disposable
        }
        return single
    }

    private func glob(_ pattern: String, from paths: [Path]) -> Observable<[Path]> {
        let single: Single<[Path]> = Single.create { observer in
            observer(.success(paths.flatMap { $0.glob(pattern) }))
            let disposable = Disposables.create()
            return disposable
        }
        return single.asObservable()
    }
}
