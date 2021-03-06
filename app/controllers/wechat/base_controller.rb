# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  layout 'wechat'

  skip_before_action :verify_authenticity_token
  before_action :authenticate, except: %w{verify}
  before_action :set_current_user, except: %w{verify}
  before_action :sign_up, except: %w{verify}

  def verify
    if params[:signature] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      if request.post?
        notification = MultiXml.parse(request.raw_post)['xml']
      end
      render text: params[:echostr]
    else
      render text: 'failure'
    end
  end

  def error
  end

  protected
    def authenticate
      redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.key[:wechat][:appid]}&redirect_uri=http%3A%2F%2Fdevelopment.luggagep.com%2Fwechat%2Fsign_in&response_type=code&scope=snsapi_base&state=authenticate#wechat_redirect" unless session['user']
    end

    def set_current_user
      @current_user = User.find(session['user']['id'])
    end

    def sign_up
      redirect_to wechat_sign_up_form_path if @current_user.unactivated?
    end

    def set_before_path
      session['before_path'] = request.path
    end

    def set_consignee
      redirect_to new_wechat_consignee_path if @current_user.consignees.blank?
    end
end