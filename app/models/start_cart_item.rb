class StartCartItem < ApplicationRecord

    def self.addtocart(user_id, quantity, stock_code)
        skip = 0
        if quantity > 0
            StartCartItem.all.each do |item|
                if item[:owner_users_id] == user_id
                    if item[:stock_code] == stock_code
                        StartCartItem.where(:id => item[:id]).update_all(:quantity => item[:quantity].to_i + quantity)
                        skip = 1
                    end
                end
            end
            if skip == 0
                StartCartItem.create!(owner_users_id: user_id, stock_code: stock_code, quantity: quantity)
            end
        end 
    end

    def self.removefromcart(cart_id)
        StartCartItem.destroy(cart_id)
    end

    def self.addstockstoholding(user_id)
        valueisok = 0
        StartCartItem.all.each do |item|
            if item[:owner_users_id] == user_id
                # test for up to date value and change var valueisok
            end
        end
        if valueisok == 0
            StartCartItem.all.each do |item|
                if item[:owner_users_id] == user_id
                    Holding.create!(owner_users_ID: user_id, stock_code: item[:stock_code], quantity: item[:quantity], asking: 50)
                end
            end
            Holding.create!(owner_users_ID: user_id, stock_code: "AUD", quantity: 10000, asking: 0)
            User.where(:id => user_id).update_all(:signinstep => 2 ) 
        end
    end
end
