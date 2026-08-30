require "fileutils"

module RailsDbDump
  class Runner
    KEEP_DUMP_COUNT = 3
    private_constant :KEEP_DUMP_COUNT

    def initialize(file: nil, config: nil, application_name: nil)
      @file = file.nil? || file.to_s.strip.empty? ? nil : file
      @config = config || ActiveRecord::Base.connection_db_config.configuration_hash
      @application_name = application_name
    end

    def call
      FileUtils.mkdir_p(File.dirname(file)) if file

      with_pgpassword do
        success = Kernel.system(*build_command, out: file || STDOUT)
        raise Error, "DB dump failed" unless success
      end

      cleanup_old_dumps if file

      file
    end

    private

    attr_reader :file, :config, :application_name

    def cleanup_old_dumps
      backup_dir = File.dirname(file)
      dump_files = Dir.glob(File.join(backup_dir, "*.dump")).sort_by { |path| File.mtime(path) }.reverse

      dump_files.drop(KEEP_DUMP_COUNT).each do |old_file|
        File.delete(old_file) if File.file?(old_file)
      end
    end

    def default_file(application_name)
      "db/backups/#{application_name || application_name_from_rails}_#{Time.current.strftime('%Y%m%d%H%M%S')}.dump"
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
        "pg_dump",
        "--host", config[:host].to_s,
        "--username", config[:username].to_s,
        "--verbose",
        "--clean",
        "--no-owner",
        "--no-acl",
        "--format=c",
        config[:database].to_s
      ]
    end
  end
end
