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
        total = getcarttotal(user_id)
        if total <= 10001
            StartCartItem.all.each do |item|
                if item[:owner_users_id] == user_id
                    Holding.create!(owner_users_ID: user_id, stock_code: item[:stock_code], quantity: item[:quantity], asking: 50)
                end
            end
            Holding.create!(owner_users_ID: user_id, stock_code: "AUD", quantity: 10000, asking: 0)
            User.where(:id => user_id).update_all(:signinstep => 2 ) 
        end
    end

    def self.getcarttotal(user_id)
        @total = 0
        StartCartItem.all.each do |item|
            if item[:owner_users_id] == user_id
                @total = @total + (item[:quantity] * Holding.getlivestockprice(item[:stock_code]))
                p "!!!!! Cart = #{ @total}----- #{item[:quantity]} of #{Holding.getlivestockprice(item[:stock_code])}"
            end
        end
        p "!!!!! Cart = #{ @total}-"
        return @total
    end
end
