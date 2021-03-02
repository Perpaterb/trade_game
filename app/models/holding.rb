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
            if holdings[:owner_users_ID] == users_id
                if holdings[:stock_code] != "AUD"
                    if holdings[:quantity] <= 0
                        Holding.destroy(holdings[:id])
                    end
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

end
