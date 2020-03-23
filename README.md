# clg

```
% clg --help
OVERVIEW: clg, generates Color stuffs: Swift code, Objective-C code, Color Set, colors.xml, clr file, and JSON

USAGE: clg [--version] <subcommand>

OPTIONS:
  -v, --version           Print version
  -h, --help              Show help information.

SUBCOMMANDS:
  clr                     generates clr file from input
  json                    generates JSON from clr file OR CSV file OR ASE file
                          a.k.a. "Adobe Swatch Exchange"
  code                    generates Swift code, Objective-C code, Color Set,
                          colors.xml from input
```

## subcommands

### clr

generates clr file from input

```sh
clg clr --output ~/Library/Colors sample.json
```

#### Options

- `--output`, `-o`
    - path for output directory

### json

generates JSON from

- clr file
- CSV file
- ASE file a.k.a. "Adobe Swatch Exchange"


```sh
clg json --output sample.json ~/Library/Colors/sample.clr

clg json --output sample.json ~/somewhere/sample.ase

clg json --output sample.json ~/somewhere/sample.csv
```

CSV file format should be like below

```
<Color Name>,<Red 256>,<Green 256>,<Blue 256>
<Color Name>,<Red 256>,<Green 256>,<Blue 256>
<Color Name>,<Red 256>,<Green 256>,<Blue 256>
```

#### Options

- `--output`, `-o`
    - path for output
        - use input file name if path is directory

### code

generates Swift code, Objective-C code, Color Set, colors.xml from input

```sh
clg code --output ~/somewhere/ --code swift sample.json
```

#### Options

- `--output`, `-o`
    - directory path for output
- `--code`, `-c`
    - generate specific type of code file
        - `swift`
        - `objc`
        - `colorset`
        - `android`

## Installation

Requires macOS Catalina.

Using homebrew:

```
brew install griffin-stewie/clg/clg
```