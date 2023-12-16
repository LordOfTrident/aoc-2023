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

moveAndMark(board, 0, 0, Dir.Right, marked)

var sum = 0
for row in marked:
    for tile in row:
        if tile.find(true) != -1:
            sum += 1

echo sum
