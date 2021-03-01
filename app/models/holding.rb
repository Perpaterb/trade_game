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
end
