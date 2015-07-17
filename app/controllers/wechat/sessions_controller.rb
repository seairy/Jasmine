# -*- encoding : utf-8 -*-
class Wechat::SessionsController < Wechat::BaseController
  skip_before_action :authenticate
  skip_before_action :set_current_user
  skip_before_action :complete_information

  def force_new
  end

  def force_create
    user = User.where(open_id: params[:open_id]).first
    if user
      session[:user] = { id: user.id }
      redirect_to wechat_dashboard_path
    else
      redirect_to wechat_force_signin_path, alert: 'Open ID不存在，请重新输入'
    end
  end

  def create
    user = User.find_or_create(Wechat::Base.find_open_id(params[:code]))
    session[:user] = { id: user.id }
    redirect_to wechat_dashboard_path
  end
end