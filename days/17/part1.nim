# https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

import std/heapqueue
import std/sequtils

var board = newSeq[seq[int]]()
for line in lines "input.txt":
    var row = newSeq[int]()
    for ch in line:
        row.add(int(ch) - int('0'))

    board.add(row)

type
    Data = tuple[
        pos: tuple[x: int, y: int],
        dir: int,
        s:   int,
    ]

var
    sum    = high(int)
    gx     = board[0].len - 1
    gy     = board.len - 1
    dirMap = [(0, -1), (-1, 0), (0, 1), (1, 0)]
    hq     = initHeapQueue[Data]()
    seen   = newSeq[Data]()
    bw     = newSeqWith(board.len, newSeqWith(board[0].len, newSeq[int](2)))

hq.push((pos: (0, 0), dir: 0, s: 0))
hq.push((pos: (0, 0), dir: 1, s: 0))

while hq.len != 0:
    var
        (pos, dir, s) = hq.pop()
        (x, y) = pos

    if bw[y][x][dir mod 2] != 0 and bw[y][x][dir mod 2] <= s:
        continue

    bw[y][x][dir mod 2] = s;
    if x == gx and y == gy:
        sum = min(sum, s)
        continue

    for id in [1, 3]:
        var
            (nx, ny, ns) = (x, y, s)
            nd = (dir + id) mod 4

        for i in 1 .. 3:
            var (dx, dy) = dirMap[nd]
            nx += dx
            ny += dy

            if not (nx >= 0 and nx < board[0].len and ny >= 0 and ny < board.len):
                break

            ns += board[ny][nx]
            hq.push((pos: (nx, ny), dir: nd, s: ns))

echo sum
