require "active_record"
require "bundler/setup"
require "dynamic_model"

require "byebug"

ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                        database: File.dirname(__FILE__) + "/dynamic_model_db.sqlite3")


require "#{File.dirname(__FILE__)}/support/schema.rb"
require "#{File.dirname(__FILE__)}/support/helpers.rb"
require "#{File.dirname(__FILE__)}/support/models/data_attribute.rb"
require "#{File.dirname(__FILE__)}/support/models/data_object.rb"
require "#{File.dirname(__FILE__)}/support/models/data_type.rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
