

class Apolo
# 00 01 02
# 03 __ 05
# 06 07 08

# (-1,-1) (-1, 0) (-1, 1)
# ( 0,-1) ( 0, 0) ( 0, 1)
# ( 1,-1) ( 1, 0) ( 1, 1)

	def initialize(x = 4, y = 4, lives = [[1,1],[1,2]])
		@length_x = x
		@length_y = y
		@initial_status = lives
		@board = Array.new(@length_y){Array.new(@length_x,false)}
		lives.each do |l|
			@board[l[1]][l[0]] = true
		end
	end

	def update(time = 1,delay=0.3)
		(0...time).each do |t|
			newBoard = Array.new(@length_y){Array.new(@length_x,false)}
			(0...@length_y).each do |l|
				(0...@length_x).each do |p|
					alive = switch(@board,surround_with(@length_x,@length_y,p,l),@board[l][p])
					newBoard[l][p] = alive
				#	p "(#{p},#{l}) is alive!" if alive
				end	
			end
			@board = newBoard
			sleep delay
			self.draw(t)
		end
	end

	def reset
		@board = Array.new(@length_y){Array.new(@length_x,false)}
		@initial_status.each do |l|
			@board[l[1]][l[0]] = true
		end
	end

	def draw(order='-')
		point = "-----"
		ten	= "-----"
		(0..@length_x/10).each do |t|
			point << '0123456789'
			ten << "%-10s" % t
		end
		print ten << "\n"
		print point << "\n"
		(0...@length_y).each do |line|
			single = "%04d|"%line
			(0...@length_x).each do |x|
				if @board[line][x]
					single << "H"
				else
					single << " "
				end
			end
			print "#{single}|\n"
		end
		print "#{point}#{ten}#{order}\n"
	end

	alias to_s draw

:private
	def surround_with(length_x,length_y,x=0,y=0)
		points = [
			[x-1,y-1],[x-1,y],[x-1,y+1],
			[x,y-1],[x,y+1],
			[x+1,y-1],[x+1,y],[x+1,y+1]
		]
		
		points.delete_if do |o|
			o[0] < 0 || o[0] > length_x - 1 ||
			o[1] < 0 || o[1] > length_y - 1
		end
	end

	def switch(board,surrounds,alive)
		count = 0
		surrounds.each do |p|
			count += 1 if board[p[1]][p[0]]
		end
	#	p "#{alive},#{count}"
		alive && (count == 2 || count ==3) ||
		!alive && (count == 3) 
	end

end

a=Apolo.new(158,58,[[73,23],[73,24],[73,25],[72,24],[74,23]])
b=Apolo.new(100,50,[[48,25],[49,25],[48,26],[49,26],[50,27],[50,28],[51,27],[51,28]])