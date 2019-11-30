# frozen_string_literal: true

require "rails_helper"
require "generator_spec"

require "generators/kadim/host/scaffold_controller/scaffold_controller_generator"

RSpec.describe Kadim::Host::ScaffoldControllerGenerator, type: :generator do
  destination File.join(Rails.root, "tmp")

  arguments %w(User)

  before do
    prepare_destination
    run_generator
  end

  it "generates controller" do
    assert_file "app/controllers/kadim/users_controller.rb" do |content|
      assert_match(/module Kadim\n  class UsersController < ApplicationController/, content)

      assert_instance_method :index, content do |m|
        assert_match(/@users = User\.all/, m)
      end

      assert_instance_method :show, content

      assert_instance_method :new, content do |m|
        assert_match(/@user = User\.new/, m)
      end

      assert_instance_method :edit, content

      assert_instance_method :create, content do |m|
        assert_match(/@user = User\.new\(user_params\)/, m)
        assert_match(/@user\.save/, m)
      end

      assert_instance_method :update, content do |m|
        assert_match(/@user\.update\(user_params\)/, m)
      end

      assert_instance_method :destroy, content do |m|
        assert_match(/@user\.destroy/, m)
        assert_match(/User was successfully destroyed/, m)
      end

      assert_instance_method :set_user, content do |m|
        assert_match(/@user = User\.find\(params\[:id\]\)/, m)
      end

      assert_match(/def user_params/, content)
      assert_match(/params\.require\(:user\)\.permit\(:about, :admin, :birthdate, :email, :last_login, :login_count, :name\)/, content)
    end
  end

  it "generates a helper module" do
    assert_file "app/helpers/kadim/users_helper.rb", /module Kadim\n  module UsersHelper/
  end

  it "generates views" do
    %w(index edit new show).each do |view|
      assert_file "app/views/kadim/users/#{view}.html.erb"
    end
    assert_no_file "app/views/layouts/kadim/users.html.erb"
  end
end
