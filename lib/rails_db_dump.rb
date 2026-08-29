require "rails_db_dump/version"
require "rails_db_dump/engine" if defined?(Rails)

module RailsDbDump
  class Error < StandardError; end
end
