require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'sinatra'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rspec

  config.before(:each) { DataMapper.auto_migrate! }
end
