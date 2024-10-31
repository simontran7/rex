# usage

## program structure

All tower source code must be written in a UTF-8 encoded file with the `.rex` file extension.

They must contain an entry point called `main()`

```
fn main() -> void {
  // your code
}
```

## execution

compile your code with `rex build [filename].rex`

for more complicated compilation, Makefiles are the recommended tool
