type
    Marked = array[4, bool]
    Dir = enum
        Up, Left, Down, Right

proc moveInDir(x: int, y: int, dir: Dir): (int, int) =
    var (x, y) = (x, y)
    if   dir == Dir.Up:    y -= 1
    elif dir == Dir.Left:  x -= 1
    elif dir == Dir.Down:  y += 1
    elif dir == Dir.Right: x += 1
    (x, y)

proc moveAndMark(board: seq[string], x: int, y: int, dir: Dir, marked: var seq[seq[Marked]]) =
    var
        (w, h)      = (board[0].len, board.len)
        (x, y, dir) = (x, y, dir)

    while true:
        if x < 0 or x >= w or y < 0 or y >= h:
            return
        elif marked[y][x][ord(dir)]:
            return

        marked[y][x][ord(dir)] = true
        var tile = board[y][x]

        if tile == '\\':
            if   dir == Dir.Up:    dir = Dir.Left
            elif dir == Dir.Left:  dir = Dir.Up
            elif dir == Dir.Down:  dir = Dir.Right
            elif dir == Dir.Right: dir = Dir.Down
        elif tile == '/':
            if   dir == Dir.Up:    dir = Dir.Right
            elif dir == Dir.Left:  dir = Dir.Down
            elif dir == Dir.Down:  dir = Dir.Left
            elif dir == Dir.Right: dir = Dir.Up
        elif tile == '|' and (dir == Dir.Left or dir == Dir.Right):
            var (x1, y1) = moveInDir(x, y, Dir.Up)
            moveAndMark(board, x1, y1, Dir.Up, marked)

            var (x2, y2) = moveInDir(x, y, Dir.Down)
            moveAndMark(board, x2, y2, Dir.Down, marked)
            return
        elif tile == '-' and (dir == Dir.Up or dir == Dir.Down):
            var (x1, y1) = moveInDir(x, y, Dir.Left)
            moveAndMark(board, x1, y1, Dir.Left, marked)

            var (x2, y2) = moveInDir(x, y, Dir.Right)
            moveAndMark(board, x2, y2, Dir.Right, marked)
            return

        (x, y) = moveInDir(x, y, dir)

var
    board  = newSeq[string]()
    marked = newSeq[seq[Marked]]()

for line in lines "input.txt":
    board.add(line)

    var markedLine = newSeq[Marked]()
    for _ in line:
        markedLine.add([false, false, false, false])

    marked.add(markedLine)

proc getEnergizedCount(board: seq[string], x: int, y: int, dir: Dir,
                       marked: var seq[seq[Marked]]): int =
    moveAndMark(board, x, y, dir, marked)

    # Count energized tiles
    var sum = 0
    for row in marked:
        for tile in row:
            if tile.find(true) != -1:
                sum += 1

    # Clear the marked tiles
    for y in 0 .. marked.len - 1:
        for x in 0 .. marked[0].len - 1:
            marked[y][x] = [false, false, false, false]

    sum

# Top and bottom rows
var most = 0
for x in 0 .. board[0].len - 1:
    var
        count1 = getEnergizedCount(board, x, 0, Dir.Down, marked)
        count2 = getEnergizedCount(board, x, board.len - 1, Dir.Up, marked)

    if count1 > most: most = count1
    if count2 > most: most = count2

# Leftmost and rightmost columns
for y in 0 .. board.len - 1:
    var
        count1 = getEnergizedCount(board, 0, y, Dir.Right, marked)
        count2 = getEnergizedCount(board, board[0].len - 1, y, Dir.Left, marked)

    if count1 > most: most = count1
    if count2 > most: most = count2

echo most
