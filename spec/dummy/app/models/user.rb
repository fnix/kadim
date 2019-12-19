# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :video
  has_many_attached :photos
end
