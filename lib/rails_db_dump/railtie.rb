require "rails/railtie"

module RailsDbDump
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("tasks.rb", __dir__)
    end
  end
end
