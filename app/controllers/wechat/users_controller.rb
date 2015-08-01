# -*- encoding : utf-8 -*-
class Wechat::UsersController < Wechat::BaseController
  skip_before_action :authenticate, only: %w{force_create}
  skip_before_action :set_current_user, only: %w{force_create}
  skip_before_action :sign_up

  def force_create
    user = User.faker
    session[:user] = { id: user.id }
    redirect_to wechat_dashboard_path
  end

  def sign_up_form
  end

  def sign_up
    begin
      raise InvalidPhone.new unless !!(user_params[:phone] =~ /^1\d{10}$/)
      raise InvalidVerificationCode.new unless !!(params[:verification_code] =~ /^\d{4}$/)
      raise InvalidNickname.new unless !!(user_params[:nickname] =~ /^[0-9A-Za-z_\u4e00-\u9fa5]{4,16}$/)
      @current_user.sign_up(phone: user_params[:phone], verification_code: params[:verification_code], nickname: user_params[:nickname])
      render json: AjaxMessenger.new
    rescue InvalidPhone
      render json: AjaxMessenger.new('无效的手机号', false)
    rescue InvalidVerificationCode
      render json: AjaxMessenger.new('无效的验证码', false)
    rescue InvalidNickname
      render json: AjaxMessenger.new('无效的昵称', false)
    rescue InvalidState
      render json: AjaxMessenger.new('无效的用户状态', false)
    rescue DuplicatedPhone
      render json: AjaxMessenger.new('手机号已被注册', false)
    rescue DuplicatedNickname
      render json: AjaxMessenger.new('昵称已被使用', false)
    rescue IncorrectVerificationCode
      render json: AjaxMessenger.new('错误的验证码', false)
    end
  end

  protected
    def user_params
      params.require(:user).permit!
    end
end