import math

dirs = {
    "U": ( 0, -1),
    "L": (-1,  0),
    "D": ( 0,  1),
    "R": ( 1,  0),
}

x = 0
y = 0
border   = 0
vertices = []

for line in open("input.txt"):
    parts = line.split()

    length   = int(parts[1])
    (dx, dy) = dirs[parts[0]]
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
