class Player

  GRAVITY = 100
  JUMP_TIME = 0.3
  JUMP_POWER = -250
  INCREASE_GRAVITY = 10
  attr_accessor :x, :y, :dead

  def load_image(window)
    image = ''
    images = ['media/flappy-1.png', 'media/flappy-2.png', 'media/flappy-3.png']
    sec = (Gosu::milliseconds / 1000).to_s.split(//).last
    if ['0', '3' , '6', '9'].include? sec
      image = images[0]
    elsif ['1', '4', '7'].include? sec
      image = images[1]
    else
      image = images[2]
    end
    @player_image = Gosu::Image.new(image)
  end

  def initialize(window)
    @player_image = load_image(window)
    @window = window

    @velocityY = 0
    @gravity = 50
    @delta = 0.25

    @space = false
    @space_before = false

    @jump = false
    @jump_max = 0.3
    @jump_start = 0

    @dead = false

    reset
  end

  # Reset position of the bird
  def reset
    @x = @window.width / 4
    @y = @window.height / 2
    @a = 0
  end

  # Draw player image
  def draw
    @player_image = load_image(@window)
    @player_image.draw_rot(@x, @y, 1, @a)
  end

  # Update position, acceleration and gravity of the bird
  def update
    dead_if_touch_ground
    bird_fall if @dead
    bird_fly if !@dead
  end

  # Move bird sprite when user hit space
  def move
    @space = user_hit_space?
    jump_start if @space && !@space_before
    update_jump_params if @jump_start > 0
    @space_before = @space
  end

  # Is bird is dead ?
  # @return [Boolean]
  def killed?
    (@y == @window.ground_y - @player_image.height/2) ? true : false
  end

  # The bird is dead if he touch the ground
  def dead_if_touch_ground
    @dead = true if @y >= @window.ground_y - @player_image.height/2
  end

  # Is the bird hit a wall ?
  def through_wall?(other)
    @x > other.x + (other.width/2)
  end

  # Does the bird touch anything
  def collision?(other)
    @y + @player_image.height/2 > other.y &&
    @y - @player_image.height/2 < other.y + other.height &&
    @x + @player_image.width/2  > other.x &&
    @x - @player_image.width/2  < other.x + other.width
  end

  # Does the use hit space key
  # @return [Boolean]
  def user_hit_space?
    return true if @window.button_down?(Gosu::KbSpace)
    return false if !@window.button_down?(Gosu::KbSpace)
  end

  # Set @jump_start with Gosu seconds
  def jump_start
    @jump_start = Gosu::milliseconds / 1000.0
  end

  # Stop jump if its duration > JUMP_TIME.
  # Else update acceleration used during jump activation
  def update_jump_params
    @gravity = GRAVITY
    if ((Gosu::milliseconds / 1000.0) - @jump_start) > JUMP_TIME
      @jump_start = 0
    else
      @velocityY = JUMP_POWER
      @a = -45
      @a = -22 if ((Gosu::milliseconds / 1000.0) - @jump_start) > JUMP_TIME / 3
      @a = 0 if ((Gosu::milliseconds / 1000.0) - @jump_start) > (JUMP_TIME*2 / 3)
    end
  end

  # Bird fall to the ground
  def bird_fall
  if @y < @window.ground_y - @player_image.height/2
      @gravity += INCREASE_GRAVITY
      @a += 25
      @a = [@a,90].min
      @y += @gravity * @window.delta
    else
      @y = @window.ground_y - @player_image.height/2
    end
  end

  # Bird fly when all is done
  def bird_fly
    move
    margin = 20
    @y += @velocityY * @window.delta if @y > @velocityY * @window.delta + margin
    @gravity += INCREASE_GRAVITY
    @a += 0.5
    @a = [@a,90].min
    @y += @gravity * @window.delta
  end

end
