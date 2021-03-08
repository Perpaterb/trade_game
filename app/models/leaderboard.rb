class Leaderboard < ApplicationRecord

    def self.updateLeaderboard(users, holding)
        uptodate = 0 
        timer = Leaderboard.where(:username => "timer").first
        if timer[:created_at] >= DateTime.now - 24.hours
            uptodate = 1
        end
        if uptodate == 0
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
        return Leaderboard.all.order(:net_worth)
    end 

end
