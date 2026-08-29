require "spec_helper"

RSpec.describe RailsDbDump do
  it "has a version number" do
    expect(RailsDbDump::VERSION).not_to be nil
  end

  it "delegates call to Runner" do
    runner = instance_double(RailsDbDump::Runner, call: "dump.dump")
    expect(RailsDbDump::Runner).to receive(:new).with("arg1", foo: "bar").and_return(runner)

    expect(RailsDbDump.call("arg1", foo: "bar")).to eq("dump.dump")
  end

  it "delegates restore to Restore" do
    restorer = instance_double(RailsDbDump::Restore, call: "dump.dump")
    expect(RailsDbDump::Restore).to receive(:new).with("arg1", foo: "bar").and_return(restorer)

    expect(RailsDbDump.restore("arg1", foo: "bar")).to eq("dump.dump")
  end
end
