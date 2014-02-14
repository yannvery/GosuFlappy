require 'gosu'
require './lib/player'
require './lib/ground'
require './lib/wall'
require './lib/wallfactory'

class GameWindow < Gosu::Window

  attr_accessor :entities, :walls, :delta

  def initialize
    super(288, 512, false)
    self.caption = "GosuFlappy Game"
    @start = false
    @delta = 0
    @last_time = 0
    @background_image = Gosu::Image.new(self, "media/background.png", true)
    @message_image = Gosu::Image.new(self, "media/message.png", true)
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

  def update_delta
    current_time = Gosu::milliseconds / 1000.0
    @delta = [current_time - @last_time, 0.25].min
    @last_time = current_time
  end

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
      @start = true if self.button_down?(Gosu::KbSpace)
      reset
    end
  end

  def draw
    @background_image.draw(0, 0, 0)
    @message_image.draw(width/2 - @message_image.width/2, 50, 0) if !@start
    # draw the score
    @font.draw("#{@score.to_i}", 10, 10, 20)
    @entities.each do |e|
      e.draw
    end
  end

  def sky_height
    @background_image.height - self.ground_height
  end

  def ground_height
    @ground.height
  end

  def ground_y
    @ground.y
  end
end

window = GameWindow.new
window.show
