class Move
  attr_reader :x
  attr_reader :y
  attr_reader :prev
  def initialize(x,y,previous)
    @x=x
    @y=y
    @prev = previous
  end
end



class Maze
  attr_reader :maze
  def load(x,y,maze_string)
    @x = x
    @y = y
    split_maze = []
    (@y-1).times do |i| #for each column
      split_maze << maze_string[i*@x..(@x + i*@x)-1] #splits the row
    end
    @maze = split_maze
  end

  def display
    puts @maze
  end



  def solve(begX,begY,endX,endY,trace=false)
    if @maze[begY][begX]=='1'
      return false
    end
    moves_completed = Hash.new(false)
    moves_queue = Queue.new
    moves_queue << Move.new(begX,begY,nil)
    moves_completed[[begX,begY]]=true
    until moves_queue.empty?
      move = moves_queue.pop
      if (move.x == endX and move.y == endY)
        if trace
          trace_solution move
        end
        return true

      else
        possible_moves = [[move.x+1,move.y],[move.x-1,move.y],[move.x,move.y+1],[move.x,move.y-1]]
        possible_moves.each do |x,y|
          begin
            if (@maze[y][x] == "0" and x>=0 and y>=0 and (moves_completed[[x,y]]==false))
              moves_queue << Move.new(x,y,move)
            end
          rescue NoMethodError #This catches the error when the y is out of bounds
          end
        end
      end
    end
    return false
  end
  def trace_solution(final)
    steps = [final]
    step = final
    until step.prev.nil?
      step = step.prev
      steps.push(step)
    end
    i=0
    steps.reverse.each do |step|
      print "step #{i}: "
      print [step.x,step.y]
      print "\n"
      i+=1
    end
  end
  def trace(begX,begY,finalX,finalY)
    return solve(begX,begY,finalX,finalY,trace=true)
  end
end





a = Maze.new
a.load(5,5,"10101111110000010101")
a.display
print "\n"
#print a.maze
#print "\n"
a.trace(0,1,3,2)