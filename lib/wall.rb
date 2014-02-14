class Wall

  attr_accessor :x, :y, :active

  def self.load_image(window,type)
    if type == "up"
      @wall_image = Gosu::Image.new(window, 'media/wall_up.png', true)
    elsif type == "down"
      @wall_image = Gosu::Image.new(window, 'media/wall_down.png', true)
    end
  end

  def initialize(window, type)
    @active = true
    @offset_y = 25
    @wall_image = self.class.load_image(window, type)
    @type = type
    @window = window
    @x = @window.width
    @y = @window.height - @window.ground_height - Random.new.rand(@offset_y..@wall_image.height )
  end

  def reset
    @x = @window.width
    @y = @window.height - @window.ground_height - Random.new.rand(@offset_y..@wall_image.height )
  end

  def draw
    @wall_image.draw(@x, @y, 1)
  end

  def update
    @x -= 2
    if self.hide?
      #self.reset
    end
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
