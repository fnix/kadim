# frozen_string_literal: true

Kadim::Engine.routes.draw do
  Kadim.app_model_paths.map(&:tableize).each do |table_name|
    resources table_name
  end
  root "application#index"
end
