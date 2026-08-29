require "spec_helper"
require "fileutils"

RSpec.describe RailsDbDump::Runner do
  let(:config) do
    {
      host: "localhost",
      username: "user",
      password: "secret",
      database: "db_name"
    }
  end

  before do
    allow(FileUtils).to receive(:mkdir_p)
    allow(Kernel).to receive(:system).and_return(true)
    allow(Dir).to receive(:glob).and_return(["db/backups/keep1.dump", "db/backups/keep2.dump"])
    allow(File).to receive(:mtime).and_return(Time.new(2026, 1, 1))
    allow(File).to receive(:file?).and_return(true)
    allow(File).to receive(:delete)
  end

  it "writes dump to provided file and returns file path" do
    runner = described_class.new(file: "db/backups/test.dump", config: config)

    expect(runner.call).to eq("db/backups/test.dump")
    expect(FileUtils).to have_received(:mkdir_p).with("db/backups")
    expect(Kernel).to have_received(:system).with(
      "pg_dump",
      "--host", "localhost",
      "--username", "user",
      "--verbose",
      "--clean",
      "--no-owner",
      "--no-acl",
      "--format=c",
      "db_name",
      out: "db/backups/test.dump"
    )
  end

  it "sets PGPASSWORD during dump" do
    runner = described_class.new(file: "db/backups/test.dump", config: config)

    expect { runner.call }.not_to raise_error
    expect(ENV["PGPASSWORD"]).to eq("secret")
  ensure
    ENV.delete("PGPASSWORD")
  end

  it "keeps only the latest dumps" do
    allow(Dir).to receive(:glob).and_return(
      [
        "db/backups/keep1.dump",
        "db/backups/keep2.dump",
        "db/backups/keep3.dump",
        "db/backups/keep4.dump"
      ]
    )
    allow(File).to receive(:mtime).and_return(Time.now)

    described_class.new(file: "db/backups/test.dump", config: config).call

    expect(File).to have_received(:delete).with("db/backups/keep4.dump")
  end
end
