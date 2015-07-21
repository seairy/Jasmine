# -*- encoding : utf-8 -*-
class Wechat::TestController < Wechat::BaseController
  skip_before_action :authenticate
  skip_before_action :set_current_user
  skip_before_action :complete_information
  
  def index
  end
end