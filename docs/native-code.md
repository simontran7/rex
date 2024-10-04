# native code

## built-in functions

| Category              | Function           |
| --------------------- | ------------------ |
| Input/Output          | print()            |
| Input/Output          | println()          |
| Input/Output          | input()            |
| Type Conversion       | int()              |
| Type Conversion       | float()            |
| Type Conversion       | string()           |
| File Handling         | open()             |
| File Handling         | close()            |
| File Handling         | read()             |
| File Handling         | write()            |

## standard library

### collections

Abstract data types are implemented with the most common operations. These are considered Access, insertion, deletion, and sometimes, updates.

- `list`: a list backed by a dynamic array
- `stack`: a stack backed by a dynamic array
- `queue`: a queue backed by a circular dynamic array
- `priority_queue`: a priority queue backed by a binary heap
- `map`: an unordered map backed by a hash table
- `set`: an unordered set backed by a hash table
- `ordered_map`: an ordered map backed by a Red-Black Tree
- `ordered_set`: an ordered set backed by a Red-Black Tree

### concurrency

Concurrency is a first class citizen. You have the option to use traditional concurrency with OS level threads, or CSP style concurrency, although the latter is the recommended option.
