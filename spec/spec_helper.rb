require 'rubygems'
require 'spork'


# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
#require Rails.root.join("config/environment")
require 'rspec/rails'
require 'rspec/autorun'
require Rails.root.join("spec/support/utilities")


Capybara.javascript_driver = :webkit
#Capybara.default_driver = :webkit

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/*.rb")].each {|f| puts f.to_s; require f}

Dir[Rails.root.join("lib/**/*.rb")].each {|f| puts f.to_s; require f}

def config_transactional(config)
  
  except_tables = %w[SystemAbility SystemModule SystemTaskStatus SystemTaskResolution State City BusinessSegment BusinessActivity].collect { |e| pluralize_without_count(2, e.underscore) }
  
  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction, {:except => except_tables}
    else
      DatabaseCleaner.strategy = :truncation, {:except => except_tables}
    end
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

RSpec.configure do |config|
  #no load that, its a realy bad ideia
  #load "#{Rails.root}/db/seeds.rb" 
  I18n.locale = :"pt-BR"
  
  config.include Devise::TestHelpers, :type => :controller
  
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true
  
  config_transactional config

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  
  config.before(:each) do
      full_example_description = "Starting #{self.class.description} #{@method_name}"
      Rails.logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")      
  end
end



# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.



Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  clear_test_dummy
  
  FactoryGirl.reload
end