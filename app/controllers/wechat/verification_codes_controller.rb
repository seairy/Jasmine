# -*- encoding : utf-8 -*-
class Wechat::VerificationCodesController < Wechat::BaseController
  skip_before_action :sign_up

  def send_for_sign_up
    begin
      raise InvalidPhone.new unless !!(params[:phone] =~ /^1\d{10}$/)
      VerificationCode.send_sign_up(user: @current_user, phone: params[:phone])
      render json: AjaxMessenger.new
    rescue InvalidPhone
      render json: AjaxMessenger.new('无效的手机号', false)
    rescue InvalidState
      render json: AjaxMessenger.new('无效的用户状态', false)
    rescue DuplicatedPhone
      render json: AjaxMessenger.new('手机号已被注册', false)
    rescue FrequentRequest
      render json: AjaxMessenger.new('请求验证码过于频繁', false)
    rescue TooManyRequest
      render json: AjaxMessenger.new('请求验证码次数过多，请联系客服', false)
    end
  end
end