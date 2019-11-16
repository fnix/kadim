module Kadim
  module ApplicationHelper
    def menu_links
      links = Kadim.app_model_names.map(&:camelize).map(&:constantize).map do |model_klass|
        link_to model_klass.model_name.human(count: :many), model_klass
      end
      safe_join(links, ' | ')
    end
  end
end
