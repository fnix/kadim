# frozen_string_literal: true

module Kadim
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :import_main_app_polymorphic_mappings
    append_view_path Kadim::MemoryResolver.instance
    layout :kadim_layout

    private
      def import_main_app_polymorphic_mappings
        Kadim::Engine.routes.polymorphic_mappings.merge! Rails.application.routes.polymorphic_mappings
      end

      def kadim_layout
        Kadim.layout ? "kadim/application_#{Kadim.layout}" : "kadim/application"
      end
  end
end
