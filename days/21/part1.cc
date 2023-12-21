#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <queue>

struct Point {
	int x, y;
};

const Point dirs[] = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}};
const auto  steps  = 64;

int main() {
	std::vector<std::string>      map;
	std::queue<Point>             points;
	std::vector<std::vector<int>> dists;

	std::ifstream file("input.txt");
	std::string   line;
	for (int y = 0; std::getline(file, line); ++ y)
		map.push_back(line);
	file.close();

	int w = map[0].length(), h = map.size();

	dists.resize(h);
	for (auto &row : dists)
		row.resize(w, -1);

	points.push({static_cast<int>(w / 2), h / 2});
	dists[h / 2][w / 2] = 0;

	while (not points.empty()) {
		auto point = points.front();
		points.pop();

		for (auto dir = 0; dir < sizeof(dirs) / sizeof(*dirs); ++ dir) {
			Point next = {point.x + dirs[dir].x, point.y + dirs[dir].y};
			if (next.x < 0 or next.x >= w or next.y < 0 or next.y >= h)
				continue;

			if (map[next.y][next.x] != '#' and dists[next.y][next.x] == -1) {
				points.push({next.x, next.y});
				dists[next.y][next.x] = dists[point.y][point.x] + 1;
			}
		}
	}

	int sum = 0;
	for (const auto &row : dists)  {
		for (auto dist : row) {
			if (dist <= steps and dist % 2 == 0)
				++ sum;
		}
	}

	std::cout << sum << std::endl;
	return 0;
}
