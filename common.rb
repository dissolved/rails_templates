# ===========================================================================================
# common.rb
#
# Usage: rails <name app> -m http://github.com/dissolved/rails_templates/raw/master/common.rb
# ===========================================================================================

# set any variables needed
app = @root.split('/').last

# remove unnecessary files
['public/favicon.ico', 'public/index.html', 'public/images/*'].each do |file|
  puts "Removing #{file}"
  run "rm #{file}"
end
run "rm -rf test"

# create the database.yml.sample file
file 'config/database.yml.sample', <<-END
defaults: &defaults
  adapter:  mysql
  username: root
  password: 
  host: localhost
  encoding: utf8

development:
  <<:       *defaults
  database: #{app}_dev

test:
  <<:       *defaults
  database: #{app}_test

production:
  <<:       *defaults
  database: #{app}
END

# create the gitignore file
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
file '.gitignore', <<-END
log/*.log
tmp/**/*
db/*.sqlite3
.DS_Store
config/database.yml
END


# gems
gem 'mislav-will_paginate',    :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'rspec', :env => 'test'
gem 'rspec-rails', :env => 'test'
gem 'webrat', :env => 'test'
gem 'cucumber', :env => 'test'
gem 'josevalim-rails-footnotes', :lib => 'rails-footnotes', :source => 'http://gems.github.com', :env => 'development'
rake 'gems:install', :sudo => true

generate('cucumber')
generate('rspec')

git :init
git :add => "."
git :commit => "-m 'Initial commit'"