# -*- encoding : utf-8 -*-
class Wechat::TasksController < Wechat::BaseController
  def index
    @tasks = Task.publishing.order(created_at: :desc).page(params[:page])
    render 'index_more', layout: false unless @tasks.first_page?
  end

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

  def show
    @task = Task.find(params[:id])
  end

  def accept
    begin
      @task = Task.find(params[:id])
      @task.accept_by(@current_user)
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('暂时无法接单，请刷新后重试', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能承接自己发布的需求', false)
    end
  end

  def accept_successful
    @task = Task.find(params[:id])
  end

  protected
    def task_params
      params.require(:task).permit!
    end
end