# tasks

## to do

- implement multi string
- implement '\'' char
- check utf-8 before compilation
- implement position for compiler errors 
    ```
    pos: Pos,
    ```
    ```
    /// the position of the token as a `start` and `end` value in `source` for compiler errors
    const Pos = struct {
        start: usize,
        end: usize,
    };
    ```
- profile scanner by checking for hotspots using perf and reviewing flamegraphs on https://www.speedscope.app/
- write parser and AST

## might do

- doc comments
- type inference
- defer keyword
- `fmt` command
- `run` command
- `test` command 
- package manager and package registry