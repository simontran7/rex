# syntax

## style guide

| data type   | naming convention |
| ----------- | ----------------- |
| file        | `snake_case`      |
| variable    | `snake_case`      |
| function    | `snake_case`      |
| method      | `snake_case`      |
| enumeration | `PascalCase`      |
| structure   | `PascalCase`      |

> [!NOTE]
> indent with four spaces

> [!WARNING]
> identifier's first character can only begin with a letter, but subsequent characters may be a letter, digit, or an underscore

> [!TIP]
> use the upcoming `rex fmt` for automatic formatting

## comments

```
// single line comment
```

```
/* multiline 
comment */
```

## values

### data types

| data type                   | category | pass type         | description                                                                      |
| --------------------------- | -------- | ----------------- | -------------------------------------------------------------------------------- |
| `int`                       | atomic   | pass by value     | a 32-bit signed integer                                                          |
| `float`                     | atomic   | pass by value     | a 64-bit IEEE 754 floating point number                                          |
| `bool`                      | atomic   | pass by value     | a 1-bit `true` or `false` boolean value                                          |
| `char`                      | atomic   | pass by value     | a 32-bit character enclosed in `'`                                               |
| `tuple(<type 1>, <type 2>)` | compound | pass by value     | a tuple containing two values of specified type enclosed in `()`                 |
| `string`                    | compound | pass by reference | a null-terminated `char` array denoted using `"` or `"""` for multi-line strings |
| `array[<type>, <length>]`   | compound | pass by reference | an array of specified type and length, enclosed in `[]`                          |

> [!NOTE]
> no value or reference will be `null`

### variables and constants

```
var <variable name>: <type> = ...;
```

```
const <constant name>: <type> = ...;
```

### supported escape sequences

| Escape Sequence | Description         |
|-----------------|---------------------|
| `\n`            | newline             |
| `\r`            | carriage return     |
| `\t`            | tab                 |
| `\b`            | backspace           |
| `\f`            | form feed           |
| `\\`            | backslash           |
| `\'`            | single quote        |
| `\"`            | double quote        |

## operators and expressions

### arithmetic and bitwise operators

| operator          | category   | description                                                             |
| ----------------- | ---------- | ----------------------------------------------------------------------- | 
| `+`               | arithmetic | add                                                                     |
| `-`               | arithmetic | substract                                                               |
| `*`               | arithmetic | multiply                                                                |
| `/`               | arithmetic | divide                                                                  |
| `%`               | arithmetic | modulo divide                                                           |
| `==`              | comparison | equality                                                                |
| `!=`              | comparison | inequality                                                              |
| `<`               | comparison | less than                                                               |
| `>`               | comparison | greater than                                                            |
| `<=`              | comparison | less or equal than                                                      |
| `>=`              | comparison | greater or equal than                                                   |
| `and`             | logical    | and                                                                     |
| `or`              | logical    | or                                                                      |
| `not`             | logical    | not                                                                     |
| `&`               | bitwise    | AND                                                                     |
| `\|`              | bitwise    | OR                                                                      |
| `^`               | bitwise    | XOR                                                                     |
| `~`               | bitwise    | NOT                                                                     |
| `<<`              | bitwise    | left shift                                                              |
| `>>`              | bitwise    | right shift                                                             |
| `=`               | assignment | assign                                                                  |
| `+=`              | assignment | add and assign                                                          |
| `-=`              | assignment | substract and assign                                                    |
| `*=`              | assignment | multiply and assign                                                     |
| `/=`              | assignment | divide and assign                                                       |
| `%=`              | assignment | modulo divide and assign                                                |
| `&=`              | assignment | bitwise AND and assign                                                  |
| `\|=`             | assignment | bitwise OR and assign                                                   |
| `^=`              | assignment | bitwise XOR and assign                                                  |
| `<<=`             | assignment | bitwise left shift and assign                                           |
| `>>=`             | assignment | bitwise right shift and assign                                          |
| `<start>..<end>`  | range      | exclusive range, where the range is from start, until and excluding end |
| `<start>..=<end>` | range      | exclusive range, where the range is from start, until and including     |

## control Flow

### conditional statements

```
if <boolean condition> {
    ...
} else if <boolean condition> {
    ...
} else {
    ...
}
```

### loops

```
while <condition> {
    ...
}
```

```
for <item> in <iterable collection> {
    ...
}
```

```
for <item> in <range> {
    ...
}
```

> [!NOTE]
> to step by a certain amount, use the `step` keyword and a positive or negative integer for the amount to step by

### match

```
match <variable or constant> {
    ... => ...,
    ..., ..., ... => ...,
    <start>..<end> => ...,
    <start>..=<end> => ...,
    else => ...,
}
```

## functions and interfaces

### function

```
func <function name>(<parameter type>: <parameter name>) -> <function return type> {
    ...
    return ...;
}
```

### interface

```
interface <interface name> {
    fn <function name>(<parameter name>: <parameter type>) -> <return type>;
}
```

## enumerations and structures

### enum

```
enum <enum name> {
    <variant 1>,
    <variant 2>,
    <variant 3>,
    <...>,
    <variant N>,
}
```

### struct

```
struct <struct name> {
    field <field name>: <type>;
    <var or const> <container name>: <type>;

    func new(<parameter name>: <parameter type>) -> <struct name> {
        this.<field name> = <parameter name>;
        ...
    }

    func <method name>(<parameter name>: <parameter type>) -> <return type> {
        ...
    }
}
```

> [!NOTE]
> if you want a struct to follow an interface, the struct declaration should be `struct <struct name> implements <interface name>`

## generics

```
func <function name>[T](<parameter name>: T) -> T {
    <var or const> <container name>: T = ...;
}
```

```
struct <struct name>[T] {
    ...
}
```

```
interface <interface name>[T] {
    ...
}
```