# frozen_string_literal: true

module Kadim
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    append_view_path Kadim::MemoryResolver.instance
  end
end
