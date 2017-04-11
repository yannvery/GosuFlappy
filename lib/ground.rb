class Ground

  attr_accessor :x, :y

  def load_image(window)
    @ground_image ||= Gosu::Image.new('media/ground.png')
  end

  def initialize(window)
    @ground_image = load_image(window)

    @window = window
    @x = 0
    @y = @window.height - @ground_image.height
    reset
  end

  def reset
    @x = 0
    @y = @window.height - @ground_image.height
  end

  def draw
    @ground_image.draw(@x, @y, 5)
  end

  def update
    @x -= 2
    reset if hide?
  end

  def hide?
    if @x + (@ground_image.width / 2) < 0
      true
    else
      false
    end
  end

  def height
    @ground_image.height
  end

end
