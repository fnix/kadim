# frozen_string_literal: true

module Kadim
  module ApplicationHelper
    def menu_links
      kadim_link = link_to("Kadim", kadim.root_path)
      links = raw_menu_links
      safe_join([kadim_link] + links, " | ")
    end

    def raw_menu_links(options = {})
      Kadim.app_model_paths.map(&:camelize).map(&:constantize).map do |model_klass|
        active_link_to model_klass.model_name.human(count: :many), model_klass, **options
      end
    end

    def upload_type
      case Kadim.upload_type
      when :direct then { direct_upload: true }
      when :resumable then { resumable_upload: true }
      else {}
      end
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?("_path", "_url")
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method)
      if method.to_s.end_with?("_path", "_url")
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end
  end
end
