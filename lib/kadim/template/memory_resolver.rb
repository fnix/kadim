# frozen_string_literal: true

require 'singleton'

module Kadim
  class MemoryResolver < ActionView::Resolver
    include Singleton

    class TemplateStore
      SmallCache = ActionView::Resolver::Cache::SmallCache

      PARTIAL_BLOCK = ->(store, partial) { store[partial] = SmallCache.new }
      PREFIX_BLOCK  = ->(store, prefix)  { store[prefix]  = SmallCache.new(&PARTIAL_BLOCK) }
      NAME_BLOCK    = ->(store, name)    { store[name]    = SmallCache.new(&PREFIX_BLOCK)  }

      # usually a majority of template look ups return nothing, use this canonical preallocated array to save memory
      NO_TEMPLATES = [].freeze

      def initialize
        @data = SmallCache.new(&NAME_BLOCK)
      end

      def find(name, prefix, partial)
        @data[name][prefix][partial].presence || NO_TEMPLATES
      end

      def add(body, path, partial)
        name = path.split('/').last
        name = name[1..-1] if partial
        prefix = path.split('/')[0..-2].join('/')
        @data[name][prefix][partial] = body
      end

      def clear
        @data.clear
      end
    end

    def initialize
      @cache = Cache.new
      @store = TemplateStore.new
    end

    def add(body, path)
      partial = path.split('/').last.start_with?('_')
      @store.add(body, path, partial)
    end

    def clear
      @cache.clear
      @store.clear
    end

    private

      def find_templates(name, prefix, partial, details, locals = [])
        return unless details[:formats].include?(:html) && details[:handlers].include?(:erb)

        body = @store.find(name, prefix, partial)
        return body if body.empty?

        path = normalize_path(name, prefix)
        identifier = "#{virtual_path(path, partial)}.html.erb (kadim memory resolver)"
        handler = ActionView::Template.registered_template_handler(:erb)
        details = { format: :html, virtual_path: virtual_path(path, partial), locals: locals }

        [ActionView::Template.new(body, identifier, handler, details)]
      end

      # Normalize name and prefix, so the tuple ["index", "users"] becomes "users/index" and the tuple
      # ["template", nil] becomes "template".
      def normalize_path(name, prefix)
        prefix.present? ? "#{prefix}/#{name}" : name
      end

      # Make paths as "users/user" become "users/_user" for partials.
      def virtual_path(path, partial)
        return path unless partial

        if index = path.rindex('/')
          path.dup.insert(index + 1, '_')
        else
          "_#{path}"
        end
      end
  end
end
