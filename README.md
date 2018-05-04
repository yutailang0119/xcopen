# xcopen

A tool to easily open a file of .xcodeproj, .xcworkspace or .playground by Xcode.

- [open] easily open a file of .xcodeproj, .xcworkspace or .playground.
- [list] explore files of .xcodeproj, .xcworkspace or .playground with a path.

## A Work In Progress

xcopen is still in active development.

## Installation

Download and install [the latest trunk Swift development toolchain](https://swift.org/download/#snapshots).

### [Mint](https://github.com/yonaskolb/mint)

```shell
$ mint install yutailang0119/xcopen
```

### From Source

```shell
$ git clone https://github.com/yutailang0119/xcopen
$ cd xcopen
$ make install
```

## Usege

### xcopen

```
OVERVIEW: Open file of .xcodeproj, .xcworkspace or .playground

USAGE: xcopen [options] subcommand [options]

OPTIONS:
--verbose   Show more debugging information
--help      Display available options

SUBCOMMANDS:
list        Explore files of .xcodeproj, .xcworkspace or .playground
open        Open file of .xcodeproj, .xcworkspace or .playground
```

#### open

```
OVERVIEW: Open file of .xcodeproj, .xcworkspace or .playground

OPTIONS:
--openFinder, -o   Whether to open in Xcode or Finder
--path, -p         Explore path. Defaults is current

POSITIONAL ARGUMENTS:
fileName           Open file name like a Xxx..xcodeproj
```

#### list

```
OVERVIEW: Explore files of .xcodeproj, .xcworkspace or .playground

OPTIONS:
--path, -p   Explore path. Defaults is current
```

## Author

[Yutaro Muta](https://github.com/yutailang0119)
- muta.yutaro@gmail.com
- [@yutailang0119](https://twitter.com/yutailang0119)

## License

xcopen is available under the MIT license. See the LICENSE file for more info.  
This software includes the work that is distributed in the Apache License 2.0.
