require 'gosu'

class DeathCounter < Gosu::Window
  def initialize
    super 400, 300 # Window dimensions
    self.caption = 'Death Counter'
    self.background_color = Gosu::Color::TRANSPARENT
    @deaths = 0
    load_count
    @font = Gosu::Font.new(30)
  end

  def update
    if Gosu.button_down?(Gosu::KB_LCONTROL) &&
       Gosu.button_down?(Gosu::KB_LSHIFT) &&
       Gosu.button_down?(Gosu::KB_D)
      increment
      sleep 1 # debounce to prevent multiple increments
    end
  end

  def draw
    @font.draw_text("Death count: #{@deaths}", 10, 10, 0, 1, 1, Gosu::Color::WHITE)
  end

  private

  def increment
    @deaths += 1
    save_count
  end

  def save_count
    File.open('death_count.txt', 'w') do |file|
      file.write(@deaths)
    end
  end

  def load_count
    if File.exist?('death_count.txt')
      @deaths = File.read('death_count.txt').to_i
    else
      @deaths = 0
    end
  end
end

# Create and show the window
DeathCounter.new.show
