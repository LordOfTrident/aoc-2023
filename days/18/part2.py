import math

dirs = [
    ( 1,  0),
    ( 0,  1),
    (-1,  0),
    ( 0, -1),
]

x = 0
y = 0
border   = 0
vertices = []

for line in open("input.txt"):
    encoded = line.split()[2]

    length   = int(encoded[2:7], 16)
    (dx, dy) = dirs[int(encoded[7])]
    x       += dx * length
    y       += dy * length
    border  += length

    vertices.append([x, y])

# https://en.wikipedia.org/wiki/Shoelace_formula
area = 0
for i in range(len(vertices) - 1):
    area -= (vertices[i][0] + vertices[i + 1][0]) * (vertices[i][1] - vertices[i + 1][1])

# https://en.wikipedia.org/wiki/Pick%27s_theorem
result = int((area - border + 2) / 2 + border)

print(result)
