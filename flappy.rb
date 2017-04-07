require 'gosu'
require './lib/player'
require './lib/ground'
require './lib/wall'
require './lib/wallfactory'

class GameWindow < Gosu::Window

  attr_accessor :entities, :walls, :delta

  # Initialize the game
  def initialize
    super(288, 512, false)
    caption = 'GosuFlappy Game'
    @start = false
    @delta = 0
    @last_time = 0
    @background_image = Gosu::Image.new('media/background.png')
    @message_image = Gosu::Image.new('media/message.png')
    @ground = Ground.new(self)
    @player = Player.new(self)
    @wallfactory = WallFactory.new(self)
    @score = 0
    @font = Gosu::Font.new(self, 'Courier', 40)
    @entities = [
      @ground,
      @player
    ]
  end

  # Reset all elements
  def reset
    @delta = 0
    @last_time = 0
    @player = Player.new(self)
    @wallfactory = WallFactory.new(self)
    @score = 0
    @walls = []
    @entities = [
      @ground,
      @player,
      @wallfactory
    ]
  end

  # Update delta param
  def update_delta
    current_time = Gosu::milliseconds / 1000.0
    @delta = [current_time - @last_time, 0.25].min
    @last_time = current_time
  end

  # Update game for each loop occurence - standard gosu method
  def update
    if @start
      update_delta
      if @player.dead
        @player.update
        @start = false if @player.killed?
      else
        @entities.each do |e|
          e.update
        end
      end
      @walls.each do |wall|
        @player.dead = true if @player.collision? wall
        @score += 0.5 if wall.score? @player
      end
      @walls.reject! {|wall| !wall.active }
    else
      if button_down?(Gosu::KbSpace)
        @start = true
        reset
      end
    end
  end

  # Draw entities of games - standard gosu method
  def draw
    @background_image.draw(0, 0, 0)
    @message_image.draw(width/2 - @message_image.width/2, 50, 10) if !@start
    # draw the score
    @font.draw("#{@score.to_i}", 10, 10, 20)
    @entities.each do |e|
      e.draw
    end
  end

  # Compute height of sky
  # @return [integer] the height of sky
  def sky_height
    @background_image.height - self.ground_height
  end

  # Return the height of ground
  # @return [integer]
  def ground_height
    @ground.height
  end

  # Return ground y position
  # @return [integer]
  def ground_y
    @ground.y
  end
end

window = GameWindow.new
window.show
