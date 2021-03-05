class Holding < ApplicationRecord
    
    def self.combinesamesame(users_id)
        comine = []
        Holding.all.each do |holdings|
            if holdings[:owner_users_ID] == users_id
                if holdings[:stock_code] != "AUD"
                    Holding.all.each do |holdings2|
                        if holdings2[:id] != holdings[:id]
                            if holdings[:stock_code] == holdings2[:stock_code]
                                if holdings[:asking] == holdings2[:asking]
                                    comine << holdings
                                end
                            end
                        end
                    end
                end                                
            end
        end
        if comine.length > 0
            comine = comine.uniq
            total = 0
            comine.each do |c|
                total += c[:quantity]
                Holding.destroy(c[:id])
            end
            Holding.create!(owner_users_ID: comine.first[:owner_users_ID], stock_code: comine.first[:stock_code], quantity: total, asking: comine.first[:asking])
        end
    end
    
    def self.removezerons(users_id)
        Holding.all.each do |holdings|
            if holdings[:stock_code] != "AUD"
                if holdings[:quantity] <= 0
                    Holding.destroy(holdings[:id])
                end
            end
        end
    end 

    def self.splitholding(holding_changes, stock_id, stock_code, users_id)
        # if Holding.exists?(stock_id)
        # else
        #     return "Error: Stock ID not found"
        #     break
        # end
        if holding_changes[:asking].to_f < -5 or holding_changes[:asking].to_f > 5
            return "Error: Asking need to be between -5 and +5"
        elsif holding_changes[:quantity].to_i > Holding.find(stock_id)[:quantity]
            return "Error: Quantity exceeds available quantity"
        else
            Holding.where(:id => stock_id).update_all(:quantity => (Holding.find(stock_id)[:quantity].to_i - holding_changes[:quantity].to_i))
            Holding.create!(owner_users_ID: users_id, stock_code: stock_code, quantity: holding_changes[:quantity].to_i, asking: holding_changes[:asking].to_f * 10 .to_i)
            return "Holdings updated"
        end
        
    end

    def self.useravaliblefunds(users_id)
        Holding.all.each do |holdings|
            if holdings[:owner_users_ID] == users_id
                if holdings[:stock_code] == "AUD"
                    return holdings[:quantity]
                end
            end
        end
    end

    def self.tradeconfirmed(trade_id , purchasing_user_id, quantity)
        quantity = quantity.to_f
        trade = Holding.find(trade_id)
        @selling_user_id = trade[:owner_users_ID]
        Holding.all.each do |holdings|
            if holdings[:owner_users_ID] == purchasing_user_id
                if holdings[:stock_code] == "AUD"
                    @purchasing_user_funds_id = holdings[:id]
                    @purchasing_user_funds = holdings[:quantity]
                end
            end
            if holdings[:owner_users_ID] == @selling_user_id
                if holdings[:stock_code] == "AUD"
                    @selling_user_funds_id = holdings[:id]
                    @selling_user_funds = holdings[:quantity]
                end
            end
        end
        
        #look up realtime cost
        #realtime_stock_value = trade[:stock_code]
        #final_cost = (realtime_stock_value * trade[:asking].to_f/10) * quantity
        realtime_stock_value = priceperunitcalc(trade)
        final_cost = (((realtime_stock_value * quantity) * 100).round)/100
        if @purchasing_user_funds > final_cost
            if trade[:quantity] >= quantity
                Holding.where(:id => @purchasing_user_funds_id).update_all(:quantity => @purchasing_user_funds - final_cost)
                Holding.where(:id => @selling_user_funds_id).update_all(:quantity => @selling_user_funds + final_cost)
                Holding.where(:id => trade_id).update_all(:quantity => trade[:quantity] - quantity)
                Holding.create!(owner_users_ID: purchasing_user_id, stock_code: trade[:stock_code], quantity: quantity, asking: 50)
                return "Trade in compleated at a final cost of $#{final_cost}"
            else
                return "Error: Avalible: $#{trade[:quantity]} --- Wanted: $#{quantity}"
            end
        else
            return "Error: Final cost of $#{final_cost} --- Avalible: $#{@purchasing_user_funds}"
        end

    end 

    def self.priceperunitcalc(trade)
        if trade[:asking] < 0            
            lower = true
            per_ammount = (trade[:asking].to_f/10)*-1
        else
            lower = false
            per_ammount = (trade[:asking].to_f/10)
        end
        stock_price = 10
        if lower
            cost = stock_price-((per_ammount/100)*stock_price)
        else
            cost = stock_price+((per_ammount/100)*stock_price)
        end
    
    end


end
