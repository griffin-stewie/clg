# clg

## subcommands

### clr

generates clr file from JSON

```sh
clg clr --output ~/Library/Colors/sample.clr sample.json
```

#### Options

- `--output`, `-o`
    - path for output

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

### code

generates Swift code, Objective-C code, colors.xml from JSON

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
        - `android`
