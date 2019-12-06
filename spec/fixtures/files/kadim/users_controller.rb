require_dependency "kadim/application_controller"

module Kadim
  class UsersController < ApplicationController
    def index
      @users = User.all
    end
  end
end
