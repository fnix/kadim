# frozen_string_literal: true

require "rails_helper"
require "generator_spec"

require "generators/kadim/host/host_generator"

RSpec.describe Kadim::HostGenerator, type: :generator do
  destination File.join(Rails.root, "tmp")

  before(:all) do
    prepare_destination
    run_generator
  end

  it { assert_file "app/assets/javascripts/kadim/application.js" }
  it { assert_file "app/assets/stylesheets/kadim/application.css" }

  it "creates kadim application controller" do
    assert_file "app/controllers/kadim/application_controller.rb" do |content|
      assert_match "module Kadim\n  class ApplicationController < ActionController::Base", content
      assert_match(/class.*protect_from_forgery with: :exception.*end/m, content)
      assert_match(/class.*append_view_path Kadim::MemoryResolver\.instance.*end/m, content)
    end
  end

  it "creates kadim application helper" do
    assert_file "app/helpers/kadim/application_helper.rb" do |content|
      assert_match "module Kadim\n  module ApplicationHelper", content
      assert_method :menu_links, content
    end
  end

  it "creates kadim index view" do
    assert_file "app/views/kadim/application/index.html.erb", /- Hi, I'm kadim!/
  end

  it "creates kadim application layout" do
    assert_file "app/views/layouts/kadim/application.html.erb" do |content|
      assert_match(/<head>.*<%= csrf_meta_tags %>.*<\/head>/m, content)
      assert_match(/<head>.*<%= csp_meta_tag %>.*<\/head>/m, content)
      assert_match(/<head>.*<%= stylesheet_link_tag 'kadim\/application'.*%>.*<\/head>/m, content)
      assert_match(/<head>.*<%= javascript_include_tag 'kadim\/application'.*%>.*<\/head>/m, content)

      assert_match(/<body>.*<div class="menu">.*<%= menu_links %>.*<\/div>.*<\/body>/m, content)
      assert_match(/<body>.*<%= yield %>.*<\/body>/m, content)
    end
  end
end
