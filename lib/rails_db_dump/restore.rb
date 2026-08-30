require "fileutils"
require "rake"

require "rails_db_dump/callable"

module RailsDbDump
  class Restore
    include Callable

    def initialize(file: nil, config: nil, application_name: nil)
      @file = file.nil? || file.to_s.strip.empty? ? nil : file
      @config = config || ActiveRecord::Base.connection_db_config.configuration_hash
      @application_name = application_name
    end

    def call
      with_pgpassword do
        recreate_database

        success = Kernel.system(*build_command)
        raise Error, "DB restore failed" unless success
      end

      file
    end

    private

    attr_reader :file, :config, :application_name

    def recreate_database
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
    end

    def default_file(application_name)
      "db/backups/#{application_name || application_name_from_rails}.dump"
    end

    def application_name_from_rails
      app_name = Rails.application.class.name.deconstantize
      (app_name.presence || Rails.application.class.name.demodulize).underscore
    end

    def with_pgpassword
      original_password = ENV["PGPASSWORD"]
      ENV["PGPASSWORD"] = config[:password].to_s if config[:password].present?

      yield
    ensure
      ENV["PGPASSWORD"] = original_password
    end

    def build_command
      [
        "pg_restore",
        "--verbose",
        "--host", config[:host].to_s,
        "--username", config[:username].to_s,
        "--clean",
        "--no-owner",
        "--no-acl",
        "--dbname", config[:database].to_s,
        file || "-"
      ]
    end
  end
end
