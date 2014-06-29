require 'debugger'
require 'colorize'

$search_radius = 5
$width = 95
$error = 1

def invalid_center?(i, j, grid_length)
	i + $search_radius >= grid_length ||
	i - $search_radius < 0 ||
	j + $search_radius >= $width ||
	j - $search_radius < 0 
end

$record_count = 0
def has_circle?(i, j, grid)
	count = 0
	test_value = grid[i - $search_radius][j]

	((i - $search_radius)..(i + $search_radius)).each do |y|
		((j - $search_radius)..(j + $search_radius)).each do |x|
			next unless ((x - j) ** 2 + (y - i) ** 2 >= $search_radius ** 2 - $error && (x - j) ** 2 + (y - i) ** 2 <= $search_radius ** 2 + $error)
			count += 1
			if count > $record_count
				$record_count = count 
				puts "#{i}, #{j}"
			end
			return false unless grid[y][x] == test_value
		end
	end
	true
end

pi_digits = File.read("pi_million.txt")
				.split("")
				.reject { |l| l == " " }
				.map(&:to_i)


grid = []
while pi_digits.count > 0
	current_row = pi_digits.take($width)
	grid << current_row
	pi_digits = pi_digits.drop($width)
end


circle_centers = []
grid.each_with_index do |row, i|
	row.each_index do |j|
		next if invalid_center?(i, j, grid.count)
		if has_circle?(i, j, grid)
			circle_centers << [i,j] 
		end
	end
end

grid.each_with_index do |row, i|
	row.each_index do |j|
		grid[i][j] = " ".colorize(background: :black) if circle_centers.include?([i, j])
	end
end

grid.each_with_index do |row, i| 
	puts "#{row.join("")} :#{i}"
end
p circle_centers
puts $record_count
