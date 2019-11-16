Kadim::Engine.routes.draw do
  Kadim.app_model_names.map(&:tableize).each do |table_name|
    resources table_name
  end
  root 'application#index'
end
