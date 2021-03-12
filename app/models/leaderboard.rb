class Leaderboard < ApplicationRecord

    #A users is wanting to look at the leaderboard.
    #if it has been more then 24 hr since update then update it with live prises
    def self.updateLeaderboard(users, holding) #needs beter name like user requesting leaderboard
        uptodate = 0 
        timer = Leaderboard.where(:username => "timer").first
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
        return Leaderboard.all.order(:net_worth)
    end 

    #An admin has requested an update of the leaderboard (skip 24hr)
    def self.adminupdateLeaderboard(users, holding)
        updatetheLeaderboard(users, holding)
    end

    #update Leaderboard BD with live prises. 
    def updatetheLeaderboard(users, holding)
        Leaderboard.destroy_all
        Leaderboard.create!(username: "timer", net_worth: 0.0)
        users.each do |user|
            @value = 0
            if user[:signinstep] == 2
                if user[:admin] != true
                    holding.each do |holdings|
                        if holdings[:owner_users_ID] == user[:id]
                            if holdings[:stock_code] == "AUD"
                                @value = @value + holdings[:quantity]
                            else
                                stock_value = Holding.getlivestockprice(holdings[:stock_code])
                                @value = @value + (holdings[:quantity] * stock_value)
                            end
                        end
                    end
                end
            end
            Leaderboard.create!(username: user[:username], net_worth: @value.round(2))
        end
    end
end
