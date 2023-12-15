import strutils

proc hash(str: string): int =
    var value = 0
    for ch in str:
        value = (value + int(ch)) * 17 mod 256
    return value

type
    Elem = object
        key:  string
        lens: int
    HashMap = array[256, seq[Elem]]

var map: HashMap

## Initialize map
for i in 0 .. map.len - 1:
    map[i] = newSeq[Elem]()

proc mapFindInBox(map: var HashMap, box: int, key: string): int =
    for i in 0 .. map[box].len - 1:
        if key == map[box][i].key:
            return i
    return -1

proc mapPerformOpDash(map: var HashMap, key: string) =
    var
        box = hash(key)
        pos = mapFindInBox(map, box, key)

    if pos >= 0:
        map[box].delete(pos)

proc mapPerformOpEquals(map: var HashMap, key: string, lens: int) =
    var
        box = hash(key)
        pos = mapFindInBox(map, box, key)

    if pos >= 0:
        map[box][pos].lens = lens
    else:
        map[box].add(Elem(key: key, lens: lens))

for line in lines "input.txt":
    for op in line.split(","):
        if op[^1] == '-':
            mapPerformOpDash(map, op[0..^2])
        else:
            var parts = op.split("=")
            mapPerformOpEquals(map, parts[0], parts[1].parseInt())

var sum = 0
for box in 0 .. map.len - 1:
    for pos in 0 .. map[box].len - 1:
        sum += (box + 1) * (pos + 1) * map[box][pos].lens

echo sum
