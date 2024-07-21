require 'ffi'

class DeathCounter
  def initialize
    @deaths = 0
    load_count
    setup_key_listener
  end

  def increment
    @deaths += 1
    save_count
    puts "Death count incremented. Current count: #{@deaths}"
  end

  def display
    puts "Current death count: #{@deaths}"
  end

  private

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

  def setup_key_listener
    FFI::Platform::Windows
    user32 = FFI::Library::ffi_lib('user32')
    user32.attach_function :GetAsyncKeyState, [:int], :short

    loop do
      if user32.GetAsyncKeyState(0x44) & 0x8000 != 0 && # 'D' key
         user32.GetAsyncKeyState(0x10) & 0x8000 != 0 && # Shift key
         user32.GetAsyncKeyState(0x11) & 0x8000 != 0    # Ctrl key
        increment
        sleep 1 # debounce to prevent multiple increments
      end
      sleep 0.1 # reduce CPU usage
    end
  end
end

# Main script execution
counter = DeathCounter.new

# Keeps the script running to listen for key presses
puts "Press Ctrl+Shift+D to increment the death count. Press Ctrl+C to exit."
loop do
  sleep 1 # Main loop doing nothing, waiting for key listener
end
