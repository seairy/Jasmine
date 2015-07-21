# -*- encoding : utf-8 -*-
class Wechat::TasksController < Wechat::BaseController
  def new
    @task = Task.new
  end

  def create
    
  end
end