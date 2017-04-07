class WallFactory

  attr_accessor :x, :y

  def initialize(window)
    @window = window
    @counter = 0
    @offset_y = 100
    @intervall = 175
  end

  # Add a 2 walls separate by a standard height
  def add
    wall_down = Wall.new(@window, 'down')
    wall_up = Wall.new(@window, 'up')
    wall_up.y = wall_down.y - wall_up.height - @offset_y
    @window.entities.push(wall_down, wall_up)
    @window.walls.push(wall_down, wall_up)
  end

  def draw
  end

  # Add a wall for each intervall
  def update
    if @counter >= @intervall
      add
      @counter = 0
    else
      @counter += 1
    end
  end
end
