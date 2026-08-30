require "rails_db_dump/version"
require "rails_db_dump/runner"
require "rails_db_dump/restore"

require "rails_db_dump/railtie" if defined?(Rails::Railtie)

module RailsDbDump
  Error = Class.new(StandardError)
end
