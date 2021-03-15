class Leaderboard < ApplicationRecord

    #A users is wanting to look at the leaderboard.
    #if it has been more then 24 hr since update then update it with live prises
    def self.updateLeaderboard(users, holding) #needs beter name like user requesting leaderboard
        p "#{Time.new} !!!!! uses ask for Leaderboard"
        uptodate = 0 
        #Quary Leaderboard table in DB to get the first where user id is -1. this is the iteem used for time keeping. 
        timer = Leaderboard.where(:user_id => -1).first
        if timer[:net_worth] == 1
            uptodate = 0
        else
            if timer[:created_at] >= DateTime.now - 24.hours
                uptodate = 1
            end
        end
        if uptodate == 0
            updatetheLeaderboard(users, holding)
        end
        #Quary Leaderboard table in DB return all in order of net worth
        return Leaderboard.all.order(:net_worth)
    end 

    #An admin has requested an update of the leaderboard (skip 24hr)
    def self.adminupdateLeaderboard(users, holding)
        p "#{Time.new} !!!!! admin update Leaderboard"
        updatetheLeaderboard(users, holding)
    end

    #update Leaderboard BD with live prices. 
    def self.updatetheLeaderboard(users, holding)
        p "#{Time.new} !!!!! update Leaderboard BD with live prices."
        #Destroy all itmes in Leaderboard table in DB
        Leaderboard.destroy_all
        #Create the timer itemin Leaderboard table in DB
        Leaderboard.create!(user_id: -1, net_worth: 0.0)
        users.each do |user|
            @value = 0
            if user[:signinstep] == 2
                if user[:admin] != true
                    holding.each do |holdings|
                        if holdings[:owner_users_ID] == user[:id]
                            if holdings[:stock_code] == "AUD"
                                @value = @value + holdings[:quantity]
                            else
                                #Run getlivestockprice on holding model
                                stock_value = Holding.getlivestockprice(holdings[:stock_code])
                                @value = @value + (holdings[:quantity] * stock_value)
                            end
                        end
                    end
                end
            end
            #Create the users item in Leaderboard table in DB only if the user has finished setup.
            Leaderboard.create!(user_id: user[:id], net_worth: @value.round(2))
        end
    end
end
