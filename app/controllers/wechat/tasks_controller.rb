# -*- encoding : utf-8 -*-
class Wechat::TasksController < Wechat::BaseController
  def new
    @task = Task.new
  end

  def create
    begin
      @task = @current_user.demanded_tasks.create_with_photographs!(task_params, params[:photographs])
      render 'create_successful'
    rescue
      redirect_to new_wechat_task_path, alert: '需求信息有误，请重试'
    end
  end

  def published
    @tasks = Task.publishing.order(created_at: :desc).page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  protected
    def task_params
      params.require(:task).permit!
    end
end