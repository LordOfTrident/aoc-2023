import strutils

proc hash(str: string): int =
    var value = 0
    for ch in str:
        value = (value + int(ch)) * 17 mod 256
    return value

var sum = 0
for line in lines "input.txt":
    for str in line.split(","):
        sum += hash(str)

echo sum
