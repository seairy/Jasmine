# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  layout 'wechat'

  before_action :find_user
  before_action :authenticate

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

  protected
    def find_user
      @current_user = User.find(session['user']['id'])
    end

    def authenticate
      redirect_to wechat_user_information_form_path if @current_user.unactivated?
    end
end