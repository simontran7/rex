<div align="center">
  <img width="200px" src="doc/rex.png">
  <h1>rex</h1>
  <p>simple, statically typed, compiled, and garbage collected programming language</p>
</div>

> [!WARNING]
> This language is experimental

## Installation (building from source)

### Requirements

[Clang C Compiler](https://clang.llvm.org/)  
[GNU Make](https://www.gnu.org/software/make/)

### Steps

1. git clone the repository

```shell
git clone https://github.com/simontran7/rex.git
```

2. `cd` into the `rex/` directory, then build the project with `make`

```shell
cd rex/
make
```

4. add the `rex` executable to your `PATH` by adding the following line to your `.bashrc` file

```shell
export PATH=$PATH:<path to the rex executable>
```

## Usage

Refer to the documentation in `doc/` for Rex's syntax, standard library, benchmarks, or the compiler's design.

## Acknowledgements

Many thanks to the creators of the resources that I used