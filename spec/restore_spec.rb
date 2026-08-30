require "spec_helper"

RSpec.describe RailsDbDump::Restore do
  let(:config) do
    {
      host: "localhost",
      username: "user",
      password: "secret",
      database: "db_name"
    }
  end

  before do
    allow(Kernel).to receive(:system).and_return(true)
    allow(Rake::Task).to receive(:[]).with("db:drop").and_return(double(invoke: true))
    allow(Rake::Task).to receive(:[]).with("db:create").and_return(double(invoke: true))
  end

  it "recreates the database and restores from file" do
    restorer = described_class.new(file: "db/backups/test.dump", config: config)

    expect(restorer.call).to eq("db/backups/test.dump")
    expect(Kernel).to have_received(:system).with(
      "pg_restore",
      "--verbose",
      "--host", "localhost",
      "--username", "user",
      "--clean",
      "--no-owner",
      "--no-acl",
      "--dbname", "db_name",
      "db/backups/test.dump"
    )
  end

  it "sets PGPASSWORD during restore" do
    restorer = described_class.new(file: "db/backups/test.dump", config: config)

    allow(Kernel).to receive(:system) do
      expect(ENV["PGPASSWORD"]).to eq("secret")
      true
    end

    expect { restorer.call }.not_to raise_error
    expect(ENV).not_to have_key("PGPASSWORD")
  ensure
    ENV.delete("PGPASSWORD")
  end
end
