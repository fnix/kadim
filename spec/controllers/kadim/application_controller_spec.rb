# frozen_string_literal: true

require "rails_helper"

RSpec.describe Kadim::ApplicationController, type: :controller do
  routes { Kadim::Engine.routes }

  context "GET #index without layout configured" do
    before do
      Kadim.layout = nil
      get :index
    end

    it { should render_template(layout: "kadim/application") }
  end

  context "GET #index with bulma as layout" do
    before do
      Kadim.layout = :bulma
      get :index
    end

    it { should render_template(layout: "kadim/bulma/application") }
  end
end
