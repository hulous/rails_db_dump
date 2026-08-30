namespace :db do
  desc "Dump the Rails database to stdout"
  task :dump do
    require "rails_db_dump/runner"

    dump_file = ENV["RAILS_DB_DUMP_FILE"]
    runner = RailsDbDump::Runner.new(file: dump_file)
    runner.call
  end

  desc "Restore the Rails database from a dump file"
  task :restore do
    require "rails_db_dump/restore"

    dump_file = ENV["RAILS_DB_DUMP_FILE"]
    RailsDbDump::Restore.new(file: dump_file).call
  end
end
