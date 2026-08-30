require "spec_helper"

RSpec.describe RailsDbDump do
  it "has a version number" do
    expect(RailsDbDump::VERSION).not_to be nil
  end

  it "does not expose a top-level call API" do
    expect(RailsDbDump).not_to respond_to(:call)
    expect(RailsDbDump).not_to respond_to(:restore)
  end
end
