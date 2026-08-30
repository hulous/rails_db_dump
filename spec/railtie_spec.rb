require "rails"
require "rake"
require_relative "spec_helper"
require "rails_db_dump/railtie"

RSpec.describe RailsDbDump::Railtie do
  let(:original_application) { Rails.application }

  before do
    Rails.application = Class.new(Rails::Application).new
    Rails.application.config.root = Pathname.new(File.expand_path("..", __dir__))
    Rake.application = Rake::Application.new
  end

  after do
    Rails.application = original_application
    Rake.application = nil
    Rake::Task.clear
  end

  it "registers db:dump and db:restore rake tasks" do
    Rails.application.load_tasks

    expect(Rake::Task.task_defined?("db:dump")).to be true
    expect(Rake::Task.task_defined?("db:restore")).to be true
  end
end
