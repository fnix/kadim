# frozen_string_literal: true

RSpec::Matchers.define :be_url do |expected|
  match do |actual|
    actual =~ URI.regexp
  end
end
