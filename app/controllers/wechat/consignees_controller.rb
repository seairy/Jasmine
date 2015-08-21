# -*- encoding : utf-8 -*-
class Wechat::ConsigneesController < Wechat::BaseController

  def index
    @consignees = @current_user.consignees
  end

  def new
    @consignee = Consignee.new
  end

  def create
    @consignee = @current_user.consignees.new(consignee_params)
    if @consignee.save
      redirect_to wechat_consignees_path
    else
      render action: 'new'
    end
  end

  protected
    def consignee_params
      params.require(:consignee).permit!
    end
end