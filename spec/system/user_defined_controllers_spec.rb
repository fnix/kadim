require "rails_helper"

RSpec.describe "User defined controllers", type: :system do
  before do
    FileUtils.mkdir Rails.root.join("app/controllers/kadim")
    FileUtils.copy file_fixture("kadim/users_controller.rb"), Rails.root.join("app/controllers/kadim/users_controller.rb")
    Kadim.bootstrap_controllers
  end

  after do
    FileUtils.remove_dir Rails.root.join("app/controllers/kadim")
  end

  it "causes kadim to skip controller generation" do
    expect(File).not_to exist(Rails.root.join("tmp/kadim/app/controllers/kadim/users_controller.rb"))
  end
end
