require 'bundler'
Bundler.require

ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

begin
  Gem::Specification::find_by_name('catpix') # Check if lite mode by installed gems
rescue Gem::LoadError
else
  require 'catpix'
end
