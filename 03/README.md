# [Day 03](https://adventofcode.com/2023/day/3)
In Tokiscript

My first solution of part 1 took 17 seconds. I managed to optimize it to be 300ms. A pretty damn big
difference. The old 17 seconds code was this:

```
let sum = 0
foreach row, line in engine
    for let i = 0; i < line:len(); i ++ 1
        if not ByteIsDigit(line[i])
            continue
        end

        let num = "", isAdjacent = false
        while i < line:len() and ByteIsDigit(line[i])
            num ++ ByteToChar(line[i])

            if not isAdjacent and CheckAdjacent(i, row)
                isAdjacent = true
            end

            i ++ 1
        end

        sum ++ if isAdjacent then strtonum(num) else 0
    end
end
```

which was there instead of the current lines 25-46. Tokiscript can be not so slow if you know how to
properly optimize it.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
