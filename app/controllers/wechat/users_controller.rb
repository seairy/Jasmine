# -*- encoding : utf-8 -*-
class Wechat::UsersController < Wechat::BaseController
  skip_before_action :authenticate, only: %w{force_create}
  skip_before_action :set_current_user, only: %w{force_create}
  skip_before_action :complete_information

  def force_create
    user = User.faker
    session[:user] = { id: user.id }
    redirect_to wechat_dashboard_path
  end

  def information_form
  end

  def complete
  end
end