# -*- encoding : utf-8 -*-
class Wechat::SessionsController < Wechat::BaseController
  def create
    open_id = Wechat.request_open_id(params[:code])
    caddie = Caddie.find_or_create(open_id)
    session[:caddie] = { id: caddie.id, name: caddie.name }
    redirect_to caddie_players_path
  end
end