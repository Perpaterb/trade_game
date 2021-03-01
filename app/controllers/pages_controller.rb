class PagesController < ApplicationController
  before_action :authenticate_user! , only:[:admin, :holding, :trade, :mytransactions]
  before_action :admin_only , only:[:admin]

  def home
  end

  def admin
    @users = User.all
  end

  def leaderboard
    @users = User.all
    @holdings = Holding.all
  end
  
  def holding
    Holding.combinesamesame(current_user.id)
    @holding = Holding.all.order(:stock_code)
  end
  
  def trade
    @users = User.all
    @holding = Holding.all.order(:asking)
  end

  def mytransactions
    @users = User.all
    @transactions = Transaction.all
  end
  
  def admin_destroy_user
    #if params[:id] != @@loggedin_user_id
        @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_path
    #end
  end
end
