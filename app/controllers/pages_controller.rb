class PagesController < ApplicationController
  before_action :authenticate_user! , only:[:admin, :holding, :trade, :mytransactions, :stock_select]
  before_action :usernewtests , only:[:admin, :holding, :trade, :mytransactions]
  before_action :admin_only , only:[:admin]

  def usernewtests
    @new_user = User.testuserisnew(current_user.id)
    if @new_user == true
      User.new_user(current_user.id)
    end
    @userSetupNotDone = User.testusersigninsteps2(current_user.id)
    if @userSetupNotDone == true
      redirect_to stock_select_path
    end 
  end 

  def home
  end

  def admin
    @users = User.all
  end

  def leaderboard
    @users = User.all
    @holding = Holding.all
  end
  
  def stock_select
    if params[:commit] == "Add To Cart"
      StartCartItem.addtocart(current_user.id, params[:quantity].to_i, params[:stock_code])
    end
    if params[:commit] == "Remove from cart"
      StartCartItem.removefromcart(params[:cart_id])
    end
    if params[:commit] == "Submit Cart"
      StartCartItem.addstockstoholding(current_user.id)
      redirect_to holding_path
    end
    @user = User.find(current_user.id)
    @cartitems = StartCartItem.all
  end

  def holding
    if params[:commit] == "Split or Update Holding"
      @holding_message = Holding.splitholding(params[:holding], params[:stock_id], params[:stock_code], params[:users_id])
    end
    Holding.combinesamesame(current_user.id)
    Holding.removezerons(current_user.id)
    @holding = Holding.all.order(:stock_code)
  end

  def trade
    Holding.removezerons(current_user.id)
    @users = User.all
    @holding = Holding.all.order(:asking)
  end

  def view_trade
    if params[:commit] == "Open"
      @trad_details = Holding.find(params[:trade_id])
      @price_per_unit = Holding.priceperunitcalc(@trad_details)
    end
  end 

  def purchase
    if params[:commit] == "Purchase"
      @trad_details = Holding.find(params[:trade_id])
      @price_per_unit = Holding.priceperunitcalc(@trad_details)
      @user_funds = Holding.useravaliblefunds(current_user.id)
    end
  end

  def trade_confirm
    if params[:commit] == "Confirm"
      @trad_details = Holding.find(params[:trade_id])
      @price_per_unit = Holding.priceperunitcalc(@trad_details)
      @message = Holding.tradeconfirmed(params[:trade_id], current_user.id, params[:quantity])
    end
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
