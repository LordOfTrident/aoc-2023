#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <queue>

std::vector<std::string> split(const std::string &str, const std::string &delim) {
	size_t start = 0, end;
	std::vector<std::string> parts;

	while ((end = str.find(delim, start)) != std::string::npos) {
		parts.push_back(str.substr(start, end - start));
		start = end + delim.length();
	}

	parts.push_back(str.substr(start));
	return parts;
}

struct Point {
	int x, y, z;

	Point(): x(0), y(0), z(0) {}
	Point(int x, int y, int z): x(x), y(y), z(z) {}

	static Point fromString(const std::string &str) {
		auto parts = split(str, ",");
		return Point(std::stoi(parts[0]), std::stoi(parts[2]), std::stoi(parts[1]));
	}

	bool operator ==(Point point) const {
		return x == point.x and y == point.y and z == point.z;
	}

	bool operator !=(Point point) const {
		return not (*this == point);
	}

	Point operator +(const Point &point) const {
		return Point(x + point.x, y + point.y, z + point.z);
	}

	Point operator -(const Point &point) const {
		return Point(x - point.x, y - point.y, z - point.z);
	}

	Point operator +=(const Point &point) {
		x += point.x;
		y += point.y;
		z += point.z;
		return *this;
	}

	Point toStep() const {
		Point point(*this);

		if      (point.x >  1) point.x =  1;
		else if (point.x < -1) point.x = -1;

		if      (point.y >  1) point.y =  1;
		else if (point.y < -1) point.y = -1;

		if      (point.z >  1) point.z =  1;
		else if (point.z < -1) point.z = -1;

		return point;
	}
};

struct PointIt {
	Point point, step;

	PointIt(Point point, Point step): point(point), step(step) {}

	void operator ++() {
		point += step;
	}

	Point operator *() {
		return point;
	}

	bool operator ==(PointIt pointIt) {
		return point == pointIt.point;
	}

	bool operator !=(PointIt pointIt) {
		return not (*this == pointIt);
	}
};

struct Brick {
	Point a, b, step;

	Brick(Point a, Point b): a(a), b(b) {
		step = (b - a).toStep();
	}

	static Brick fromString(const std::string &str) {
		auto parts = split(str, "~");
		return Brick({Point::fromString(parts[0]), Point::fromString(parts[1])});
	}

	PointIt begin() const {
		return PointIt(a, step);
	}

	PointIt end() const {
		return PointIt(b + step, step);
	}

	void fall() {
		-- a.y;
		-- b.y;
	}
};

struct Map {
	std::vector<Brick> &bricks;
	std::vector<std::vector<std::vector<int>>> ids;

	Map(std::vector<Brick> &bricks): bricks(bricks) {
		int endX = 0, endY = 0, endZ = 0;
		for (const auto &brick : bricks) {
			endX = std::max(endX, std::max(brick.a.x, brick.b.x));
			endY = std::max(endY, std::max(brick.a.y, brick.b.y));
			endZ = std::max(endZ, std::max(brick.a.z, brick.b.z));
		}

		ids.resize(endY + 2);
		for (auto &row : ids) {
			row.resize(endX + 1);
			for (auto &col : row)
				col.resize(endZ + 1, -1);
		}

		for (std::size_t i = 0; i < bricks.size(); ++ i) {
			for (auto step : bricks[i])
				ids[step.y][step.x][step.z] = i;
		}
	}

	bool canPlaceBrick(const Brick &brick, int id1, int id2 = -1) {
		if (brick.a.y < 1 or brick.b.y < 1)
			return false;

		for (auto step : brick) {
			if (ids[step.y][step.x][step.z] != -1 and
			    ids[step.y][step.x][step.z] != id1 and ids[step.y][step.x][step.z] != id2)
				return false;
		}

		return true;
	}

	std::vector<int> getIdsOfBricksSupportedBy(int brick) {
		std::vector<int> supported;

		int lastId = -1;
		for (auto point : bricks[brick]) {
			int id = ids[point.y + 1][point.x][point.z];
			if (id == -1)
				continue;

			if (id != lastId and id != brick) {
				lastId = id;
				supported.push_back(id);
			}
		}

		return supported;
	}

	/*void print() {
		for (std::size_t y = ids.size(); y --> 0;) {
			const auto &row = ids[y];
			for (std::size_t x = 0; x < row.size(); ++ x) {
				int ida = -1;
				for (std::size_t z = 0; z < row[x].size(); ++ z) {
					if (row[z][x] != -1) {
						ida = row[z][x];
						break;
					}
				}

				std::cout << (ida != -1? (char)('A' + ida % 10) : '.');
			}
			std::cout << "  ";

			for (std::size_t x = 0; x < row.size(); ++ x) {
				int ida = -1;
				for (std::size_t z = 0; z < row[x].size(); ++ z) {
					if (row[x][z] != -1) {
						ida = row[x][z];
						break;
					}
				}

				std::cout << (ida != -1? (char)('A' + ida % 10) : '.');

			}
			std::cout << std::endl;
		}
	}*/
};

bool fallBricks(std::vector<Brick> &bricks) {
	bool brickFell, anyFell = false;
	do {
		brickFell = false;
		Map map(bricks);
		for (std::size_t i = 0; i < bricks.size(); ++ i) {
			auto brickTest = bricks[i];
			brickTest.fall();
			if (map.canPlaceBrick(brickTest, i)) {
				bricks[i].fall();
				brickFell = true;
				if (not anyFell)
					anyFell = true;
			}
		}
	} while (brickFell);

	return anyFell;
}

int countDisintegratable(std::vector<Brick> &bricks) {
	int count = 0;

	/* An even dumber approach that should 100% work. Using it to test if the main approach is
	   working properly. If it wasnt, the result given by this code would be different, but they
	   are the same.
	for (std::size_t i = 0; i < bricks.size(); ++ i) {
		std::vector<Brick> copy = bricks;
		copy[i].a.y = 0;
		copy[i].b.y = 0;

		if (not fallBricks(copy))
			++ count;
	}*/

	Map map(bricks);
	for (std::size_t i = 0; i < bricks.size(); ++ i) {
		auto supported = map.getIdsOfBricksSupportedBy(i);

		bool disintegratable = true;
		for (auto id : supported) {
			auto brickTest = bricks[id];
			brickTest.fall();

			if (map.canPlaceBrick(brickTest, i, id)) {
				disintegratable = false;
				break;
			}
		}

		if (disintegratable)
			++ count;
	}

	return count;
}

int main() {
	std::vector<Brick> bricks;

	std::ifstream file("input.txt");
	std::string   line;
	for (int y = 0; std::getline(file, line); ++ y)
		bricks.push_back(Brick::fromString(line));
	file.close();

	fallBricks(bricks);
	//Map(bricks).print();

	std::cout << countDisintegratable(bricks) << std::endl;
	return 0;
}
