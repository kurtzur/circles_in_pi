require 'debugger'
require 'colorize'

class PiCircles

	def initialize(options)
		@search_radius = options[:radius]
		@width = options[:width]
		@error = options[:error]
	end

	def invalid_center?(i, j)
		i + @search_radius >= @grid.count ||
		i - @search_radius < 0 ||
		j + @search_radius >= @width ||
		j - @search_radius < 0 
	end


	def has_circle?(i, j)
		test_value = @grid[i - @search_radius][j]

		((i - @search_radius)..(i + @search_radius)).each do |y|
			((j - @search_radius)..(j + @search_radius)).each do |x|
				next unless on_circle?([i, j], x, y)
				return false unless @grid[y][x] == test_value
			end
		end
		true
	end

	def on_circle?(center, x, y)
		i, j = center
		if (x - j) ** 2 + (y - i) ** 2 >= @search_radius ** 2 - @error
			if (x - j) ** 2 + (y - i) ** 2 <= @search_radius ** 2 + @error
				return true
			end
		end
		false
	end

	def make_grid
		pi_digits = File.read("pi.txt")
							.split("")
							.reject { |l| l == " " }
							.map(&:to_i)

		@grid = []
		while pi_digits.count > 0
			current_row = pi_digits.take(@width)
			@grid << current_row
			pi_digits = pi_digits.drop(@width)
		end
	end

	def find_circles
		@circle_centers = []
		@grid.each_with_index do |row, i|
			row.each_index do |j|
				next if invalid_center?(i, j)
				if has_circle?(i, j)
					@circle_centers << [i,j] 
				end
			end
		end
	end

	def print_grid
		@grid.each_with_index do |row, i|
			row.each_index do |j|
				if @circle_centers.include?([i, j])
					@grid[i][j] = " ".colorize(background: :black) 
				end
			end
		end

		@grid.each_with_index do |row, i| 
			puts "#{row.join("")} :#{i}"
		end
	end

	def run
		make_grid
		find_circles
		print_grid
		puts "#{@circle_centers.count} circles found."
	end

end