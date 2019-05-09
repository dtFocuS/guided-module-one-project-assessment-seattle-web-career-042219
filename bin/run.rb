require_relative '../config/environment'

$TEST_MODE = false # Setting this to true puts the program in turbo mode
$GAME_WIDTH = 85 # Set width of terminal for the game

$IS_LITE_MODE = false
begin
  Gem::Specification::find_by_name('catpix') # Check if lite mode by installed gems
rescue Gem::LoadError
  $IS_LITE_MODE = true
end

play_game
