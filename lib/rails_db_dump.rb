require "rails_db_dump/version"
require "rails_db_dump/runner"
require "rails_db_dump/restore"

module RailsDbDump
  Error = Class.new(StandardError)

  class << self
    def call(*args, **kwargs)
      Runner.new(*args, **kwargs).call
    end

    def restore(*args, **kwargs)
      Restore.new(*args, **kwargs).call
    end
  end
end
