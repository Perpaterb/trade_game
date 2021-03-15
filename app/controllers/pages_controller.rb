class PagesController < ApplicationController
  before_action :authenticate_user! , only:[:admin, :holding, :trade, :mytransactions, :stock_select]
  before_action :usernewtests , only:[:admin, :holding, :trade, :mytransactions]
  before_action :admin_only , only:[:admin]


  # testing to see if a user is new before directing letting them go to :admin, :holding, :trade, :mytransactions
  def usernewtests
    @new_user = User.testuserisnew(current_user.id)
    if @new_user == true
      #Quary User table in DB get current_user
      User.new_user(current_user.id)
    end
    @userSetupNotDone = User.testusersigninsteps2(current_user.id)
    if @userSetupNotDone == true
      redirect_to stock_select_path
    end 
  end 

  #home page
  def home
  end

  #Admin page sending all users.
  def admin
    #Quary User table in DB get all
    @users = User.all

    #if an admin has clicked the "Reset leaderboard" button
    if params[:commit] == "Reset leaderboard"
      #Quary Holding table in DB get all and send to Leaderboard model
      Leaderboard.adminupdateLeaderboard(@users, Holding.all)
    end 
  end

  # leaderboard page start by updateing the leaderboard if it has been more then 24hrs
  # then send the leaderboard and all users for avatar.
  def leaderboard
    #Quary User table in DB get all
    @users = User.all
    #Quary Holding table in DB get all and send to Leaderboard model
    Leaderboard.updateLeaderboard(@users, Holding.all)
    #Quary Leaderboard table in DB get all
    @list = Leaderboard.all
    
  end
  
  # the shopping cart for the new users sellecting thier starting stocks
  # send the user by current_user.id
  def stock_select
    #Quary User table in DB get current_user
    @user = User.find(current_user.id)
    @user_id = current_user.id

    #gett all the live prises for all the users starting stocks
    @user_starting_stock_prises = Holding.getuserstartingstockprises(@user)

    #update cart total value
    @valueofcart =StartCartItem.getcarttotal(current_user.id)

    #adding a stock to the cart
    if params[:commit] == "Add To Cart"
      StartCartItem.addtocart(current_user.id, params[:quantity].to_i, params[:stock_code])
    end

    #remove a stock from the cart
    if params[:commit] == "Remove from cart"
      StartCartItem.removefromcart(params[:cart_id])
    end

    #submit the cart and redirect to hording page
    if params[:commit] == "Submit Cart"
      StartCartItem.addstockstoholding(current_user.id)
      redirect_to holding_path
    end

    #send all crat items
    #Quary StartCartItem table in DB get all
    @cartitems = StartCartItem.all
  end

  #Holding page
  def holding

    #Split or Update a Holding with an ammount and asking price
    if params[:commit] == "Split or Update Holding"
      @holding_message = Holding.splitholding(params[:holding], params[:stock_id], params[:stock_code], params[:users_id])
    end

    #combine all a users holdings of the same stock and asking
    Holding.combinesamesame(current_user.id)

    #remove all holdings with 0 quantity 
    Holding.removezerons(current_user.id)

    #sending all hooldings in alfabet order View will pull out users.
    #Quary Holding table in DB get all in order
    @holding = Holding.all.order(:stock_code)
  end

  #trade page
  def trade

    #remove all holdings with 0 quantity
    Holding.removezerons(current_user.id)

    # Send all users and holdings in order
    #Quary User table in DB get all
    @users = User.all
    #Quary Holding table in DB get all in order
    @holding = Holding.all.order(:asking)
  end

  #user has looked on a trade
  def view_trade

    # might not need this if 
    if params[:commit] == "Open"

      #send the holding
      #Quary Holding table in DB find by trade id
      @trad_details = Holding.find(params[:trade_id])

      #send the live stock price per unit
      @price_per_unit = Holding.priceperunitcalc(@trad_details)
    end
  end 

  #user has has ented quantity to perchase and clicked Purchase.
  def purchase

    # might not need this if 
    if params[:commit] == "Purchase"

      #send the holding
      #Quary Holding table in DB find by trade id
      @trad_details = Holding.find(params[:trade_id])

      #send the live stock price per unit
      @price_per_unit = Holding.priceperunitcalc(@trad_details)

      #send the users avalible funds in AUD 
      @user_funds = Holding.useravaliblefunds(current_user.id)
    end
  end

  #user has clicked "confirm" on the deatails of the perchase they want to make.
  def trade_confirm

    # might not need this if 
    if params[:commit] == "Confirm"

      #send the holding
      #Quary Holding table in DB find by trade id
      @trad_details = Holding.find(params[:trade_id])

      #send the live stock price per unit adain. last time
      @price_per_unit = Holding.priceperunitcalc(@trad_details)

      # finalise and send massage to user 
      @message = Holding.tradeconfirmed(params[:trade_id], current_user.id, params[:quantity])
    end
  end


  #my transactions page sending all users and all transactions.
  def mytransactions
    #Quary User table in DB get all
    @users = User.all
    #Quary Transaction table in DB get all
    @transactions = Transaction.all
  end
   
end
