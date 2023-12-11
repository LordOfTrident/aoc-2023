# 🎄 [Day 04](https://adventofcode.com/2023/day/4)
In Tokiscript

This day was pretty fun. I cant really tell why, but it was funner than the other days. Maybe im just
getting more comfy writing in Tokiscript, tho it did almost shoot me in the leg this day due to the
way it handles variables and scopes with lambdas.

The function `ForeachDelimed` declares its own variable `pos`, which it uses to keep track of the
position in the string. It then calls the lambda (callback) that you passed into it. But Tokiscript
lets you access any and all variables from the lambda. So when i declared a global variable called
`pos` inside part 2 and tried to use it inside the lambda, things were not working as expected. The
local variable `pos` inside `ForeachDelimed` was overshadowing the global variable, so when i tried
to read/write `pos` inside the lambda, i was really reading the local variable that `ForeachDelimed`
declared and not the one i declared globally. If Tokiscript was really a serious language i would
have to fix this in some way but since its not, im not gonna do anything about it other than keep it
in mind. The easy fix was to just rename the variable from `pos` to `lineNum`.

The part 2 code also originally took a really long time to run and i optimized it to be almost instant.
Here is a part of the original slow code that replaced the lines 14-36:
```
let lines = freadstr("input.txt"):Split("\n")
let cards = array(lines:len()):Fill(1)

foreach pos, line in lines
    let sides   = line[(":" in line) + 2, nil]:Split(" | ")
    let winning = ParseNumberListString(sides[0])
    let yours   = ParseNumberListString(sides[1])
    let count   = 0

    foreach n in yours
        if n in winning /= nil
            count ++ 1
        end
    end

    for let i = 1; i <= count; i ++ 1
        if pos + i >= cards:len()
            break
        end

        cards[pos + i] ++ cards[pos]
    end
end
```

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
