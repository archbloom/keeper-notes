class HomeController < ApplicationController
  before_action :check_user_scope
  def index; end

  private

  def check_user_scope
    if user_signed_in?
      redirect_to notes_path
    else
      redirect_to '/users/sign_in'
    end
  end
end
