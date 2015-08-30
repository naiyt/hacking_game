module Scripts
  def self.play_game
    levels = [Level1, Level2, Level3]
    levels.each { |level| level.play}
  end
end