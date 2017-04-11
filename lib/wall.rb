class Wall

  attr_accessor :x, :y, :active

  def load_image(window,type)
    if type == 'up'
      @wall_image = Gosu::Image.new('media/wall_up.png')
    elsif type == 'down'
      @wall_image = Gosu::Image.new('media/wall_down.png')
    end
  end

  def initialize(window, type)
    @active = true
    @offset_y = 25
    @wall_image = load_image(window, type)
    @type = type
    @window = window
    @x = @window.width
    @y = @window.height - @window.ground_height - Random.new.rand(@offset_y..@wall_image.height )
  end

  def draw
    @wall_image.draw(@x, @y, 1)
  end

  def update
    @x -= 2
  end

  def score?(other)
    if @x + @wall_image.width  < other.x
      @active = false
      true
    else
      false
    end
  end

  def hide?
    if @x + (@wall_image.width) < 0
      true
    else
      false
    end
  end

  def height
    @wall_image.height
  end

  def width
    @wall_image.width
  end

end
