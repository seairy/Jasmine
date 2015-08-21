# -*- encoding : utf-8 -*-
class Wechat::TasksController < Wechat::BaseController
  before_action :publish_instruction, only: %w{new}
  before_action :accept_instruction, only: %w{accept_confirmation}

  def published
    @tasks = Task.publishing.order(created_at: :desc).page(params[:page])
    @tasks.first_page? ? render('wechat/tasks/published/list') : render('wechat/tasks/published/more', layout: false)
  end

  def demanded
    @tasks = @current_user.demanded_tasks.order(created_at: :desc).page(params[:page])
    @tasks.first_page? ? render('wechat/tasks/demanded/list') : render('wechat/tasks/demanded/more', layout: false)
  end

  def supplied
    @tasks = @current_user.supplied_tasks.order(accepted_at: :desc).page(params[:page])
    @tasks.first_page? ? render('wechat/tasks/supplied/list') : render('wechat/tasks/supplied/more', layout: false)
  end

  def new
    @task = Task.new
  end

  def create
    begin
      @task = @current_user.demanded_tasks.create_with_photographs!(task_params, params[:photographs])
      render 'create_successful'
    rescue StandardError => e
      redirect_to new_wechat_task_path, alert: '需求信息有误，请重试'
    end
  end

  def show
    @task = Task.find(params[:id])
    render (if @task.demander_id == @current_user.id
      'wechat/tasks/show/demander'
    elsif @task.supplier_id == @current_user.id
      'wechat/tasks/show/supplier'
    else
      'wechat/tasks/show/public'
    end)
  end

  def pay_deposit
    @task = @current_user.demanded_tasks.find(params[:id])
    @task.pay_deposit!
    redirect_to [:wechat, @task]
  end

  def pay_final
    @task = @current_user.demanded_tasks.find(params[:id])
    @task.pay_final!
    redirect_to [:wechat, @task]
  end

  def acceptable
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.publishing?
      raise InvalidSupplier.new if @current_user.id == @task.demander_id
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('暂时无法接单，请刷新后重试', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能承接自己发布的需求', false)
    end
  end

  def accept_confirmation
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.publishing?
      raise InvalidSupplier.new if @current_user.id == @task.demander_id
      render 'wechat/tasks/accept/confirmation'
    rescue InvalidState
      redirect_to wechat_error_path, alert: '订单状态无效'
    rescue InvalidSupplier
      redirect_to wechat_error_path, alert: '不能承接自己发布的需求'
    end
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
    render 'wechat/tasks/accept/successful'
  end

  def trashable
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless (@task.pending? or @task.publishing?)
      raise InvalidDemander.new unless @current_user.id == @task.demander_id
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('订单已在进行中，无法删除', false)
    rescue InvalidDemander
      render json: AjaxMessenger.new('不能删除别人的订单', false)
    end
  end

  def trash_confirmation
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless (@task.pending? or @task.publishing?)
      raise InvalidDemander.new unless @current_user.id == @task.demander_id
      render 'wechat/tasks/trash/confirmation'
    rescue InvalidState
      redirect_to wechat_error_path, alert: '订单已在进行中，无法删除'
    rescue InvalidDemander
      redirect_to wechat_error_path, alert: '不能删除别人的订单'
    end
  end

  def trash
    begin
      @task = Task.find(params[:id])
      @task.trash_by(@current_user)
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('订单已在进行中，无法删除', false)
    rescue InvalidDemander
      render json: AjaxMessenger.new('不能删除别人的订单', false)
    end
  end

  def trash_successful
    @task = Task.find(params[:id])
    render 'wechat/tasks/trash/successful'
  end

  def cancelable
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.shopping?
      raise InvalidSupplier.new unless @current_user.id == @task.supplier_id
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('无法取消订单', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能取消别人的订单', false)
    end
  end

  def cancel_confirmation
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.shopping?
      raise InvalidSupplier.new unless @current_user.id == @task.supplier_id
      render 'wechat/tasks/cancel/confirmation'
    rescue InvalidState
      redirect_to wechat_error_path, alert: '无法取消订单'
    rescue InvalidSupplier
      redirect_to wechat_error_path, alert: '不能取消别人的订单'
    end
  end

  def cancel
    begin
      @task = Task.find(params[:id])
      @task.cancel_by(@current_user, params[:task][:reason_of_cancellation])
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('无法取消订单', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能取消别人的订单', false)
    end
  end

  def cancel_successful
    @task = Task.find(params[:id])
    render 'wechat/tasks/cancel/successful'
  end

  def purchasable
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.shopping?
      raise InvalidSupplier.new unless @current_user.id == @task.supplier_id
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('无法确认订单', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能确认别人的订单', false)
    end
  end

  def purchase_confirmation
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.shopping?
      raise InvalidSupplier.new unless @current_user.id == @task.supplier_id
      render 'wechat/tasks/purchase/confirmation'
    rescue InvalidState
      redirect_to wechat_error_path, alert: '无法确认订单'
    rescue InvalidSupplier
      redirect_to wechat_error_path, alert: '不能取消别人的订单'
    end
  end

  def purchase
    begin
      @task = Task.find(params[:id])
      raise InvalidActualPrice.new if params[:task][:actual_price].to_i > @task.estimate_price.to_i
      @task.purchase_by(@current_user, params[:task][:actual_price].to_i)
      render json: AjaxMessenger.new(purchase_successful_wechat_task_path(@task))
    rescue InvalidState
      render json: AjaxMessenger.new('无法确认订单', false)
    rescue InvalidSupplier
      render json: AjaxMessenger.new('不能取消别人的订单', false)
    rescue InvalidActualPrice
      render json: AjaxMessenger.new('实际价格不能高于预估价', false)
    end
  end

  def purchase_successful
    @task = Task.find(params[:id])
    render 'wechat/tasks/purchase/successful'
  end

  def clearable
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.clearing?
      raise InvalidDemander.new unless @current_user.id == @task.demander_id
      render json: AjaxMessenger.new
    rescue InvalidState
      render json: AjaxMessenger.new('无法支付订单', false)
    rescue InvalidDemander
      render json: AjaxMessenger.new('不能支付别人的订单', false)
    end
  end

  def clear_confirmation
    begin
      @task = Task.find(params[:id])
      raise InvalidState.new unless @task.clearing?
      raise InvalidDemander.new unless @current_user.id == @task.demander_id
      render 'wechat/tasks/clear/confirmation'
    rescue InvalidState
      redirect_to wechat_error_path, alert: '无法支付订单'
    rescue InvalidDemander
      redirect_to wechat_error_path, alert: '不能支付别人的订单'
    end
  end

  def clear
    begin
      @task = Task.find(params[:id])
      @task.clear_by(@current_user)
      render json: AjaxMessenger.new(clear_successful_wechat_task_path(@task))
    rescue InvalidState
      render json: AjaxMessenger.new('无法支付订单', false)
    rescue InvalidDemander
      render json: AjaxMessenger.new('不能支付别人的订单', false)
    end
  end

  def clear_successful
    @task = Task.find(params[:id])
    render 'wechat/tasks/clear/successful'
  end

  protected
    def task_params
      params.require(:task).permit!
    end

    def publish_instruction
      if @current_user.novice_as_demander?
        set_before_path
        redirect_to publish_task_wechat_instruction_path unless params[:read_instruction] == 'yes'
      end
    end

    def accept_instruction
      if @current_user.novice_as_supplier?
        set_before_path
        redirect_to accept_task_wechat_instruction_path unless params[:read_instruction] == 'yes'
      end
    end
end