#I just used the method from Storer's 21a class to solve the Panama Canal puzzle
class Move
  #Class for a certain move. Done like this to trace the previous move (to get to the beginning)
  attr_reader :x #x coordinate
  attr_reader :y
  attr_reader :prev #previous move
  def initialize(x,y,previous)
    @x=x
    @y=y
    @prev = previous
  end
end

class Maze
  attr_reader :maze #list of rows and stuff
  def load(x,y,maze_string) #takes in number of x columns, y rows, and the string of 1s and 0s (1 based)
    @x = x
    @y = y
    split_maze = []
    (@y-1).times do |i| #for each column it takes that column using this formula
      split_maze << maze_string[i*@x..(@x + i*@x)-1] #splits the row
    end

    @maze = split_maze #stores it as a class variable
  end

  def display
    puts @maze.class
    puts @maze #easy because of how I implemented
  end

  def solve(begX,begY,endX,endY,trace=false)
    #For the record x and y are based on the coordinate plane, but y is upside down
    #0,0 is top left, 0,1 is one under that


    if @maze[begY][begX]=='1' or @maze[endX,endY]=='1' #if you start on a 1 you're stuck, ending on a 1 is impossible
      puts "invalid start or end state"
      return false
    end
    moves_completed = Hash.new(false) #hash of the places you've already been (to make sure you don't backtrace)
    #The key will be an array of x and y, and the default value is true
    moves_queue = Queue.new #queue of moves to check
    moves_queue << Move.new(begX,begY,nil) #The first move is the beginning X and Y
    moves_completed[[begX,begY]]=true #adds that move to the move queue (so you don't go back)
    until moves_queue.empty? #If this is empty that means there's no moves left :(
      move = moves_queue.pop #takes the first move off the queue
      if (move.x == endX and move.y == endY) #If the move you popped is the solution, you win!
        if trace #trace is default false. If you want to know how to get to that point then it can do that
          #trace_solution move
          return move
        else
          puts "solution found"
          return true
        end

      else #If it's not the solution, it creates the 4 possible moves it can go for (not checked for accuracy)
        possible_moves = [[move.x+1,move.y],[move.x-1,move.y],[move.x,move.y+1],[move.x,move.y-1]]
        possible_moves.each do |x,y| #for each of those moves
          begin
            if (@maze[y][x] == "0" and x>=0 and y>=0 and (moves_completed[[x,y]]==false))
              #To be added to the queue, the item
              moves_queue << Move.new(x,y,move)
            end
          rescue NoMethodError #This catches the error when the y is out of bounds
          end
        end
      end
    end
    puts "no solution"
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
    solution = solve(begX,begY,finalX,finalY,trace=true)
    if solution==false
      raise "No solution to trace"
    else
      trace_solution(solution)
    end
  end

  def redesign
    #maze is a list of @y @x sized items
    maze_weights = []
    @y.times do
      row = ""
      @x.times do
        row += Random.rand(2).to_s
      end
      maze_weights << row
    end
    @maze = maze_weights
  end
end





a = Maze.new
a.load(9,9,"111111111100010001111010101100010101101110101100000101111011101100000101111111111")
a.display
print "\n"
a.trace(1,1,1,4)

a.redesign
a.display