require "spec_helper"

RSpec.describe RailsDbDump do
  it "has a version number" do
    expect(RailsDbDump::VERSION).not_to be nil
  end
end
