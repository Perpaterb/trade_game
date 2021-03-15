class Holding < ApplicationRecord
    
    #combine all a users holdings of the same stock and asking but not AUD
    def self.combinesamesame(users_id)
        combine = []
        #Quary Holding table in DB loop over
        Holding.all.each do |holdings|
            if holdings[:owner_users_ID] == users_id
                if holdings[:stock_code] != "AUD"
                    #Quary Holding table in DB loop over On^2 :(
                    Holding.all.each do |holdings2|
                        if holdings2[:id] != holdings[:id]
                            if holdings[:stock_code] == holdings2[:stock_code]
                                if holdings[:asking] == holdings2[:asking]
                                    combine << holdings
                                end
                            end
                        end
                    end
                end                                
            end
        end
        if combine.length > 0
            combine = combine.uniq
            total = 0
            combine.each do |com|
                total += com[:quantity]
                #Destroy all Holdings items in the DB with the same owner and stock and asking 
                Holding.destroy(com[:id])
            end
            #Create Holding item in the DB for the combined stock.
            Holding.create!(owner_users_ID: combine.first[:owner_users_ID], stock_code: combine.first[:stock_code], quantity: total, asking: combine.first[:asking])
        end
    end
    
    #remove all holdings with 0 quantity but not AUD
    def self.removezerons(users_id)
        #Quary Holding table in DB loop over
        Holding.all.each do |holdings|
            if holdings[:stock_code] != "AUD"
                if holdings[:quantity] <= 0
                    #Destroy all Holding items that have 0 quantity and are not AUD
                    Holding.destroy(holdings[:id])
                end
            end
        end
    end 

    #Split or Update a Holding with an ammount and asking price
    def self.splitholding(holding_changes, stock_id, stock_code, users_id)
        if holding_changes[:asking].to_f < -5 or holding_changes[:asking].to_f > 5
            return "Error: Asking need to be between -5 and +5"
            #Quary Holding table in DB for itme quantity
        elsif holding_changes[:quantity].to_i > Holding.find(stock_id)[:quantity]
            return "Error: Quantity exceeds available quantity"
        else
            #Update Holding itme in DB with remaining quantity
            Holding.where(:id => stock_id).update_all(:quantity => (Holding.find(stock_id)[:quantity].to_i - holding_changes[:quantity].to_i))
            #Create Holding item in the DB with new asking and quantity
            Holding.create!(owner_users_ID: users_id, stock_code: stock_code, quantity: holding_changes[:quantity].to_i, asking: holding_changes[:asking].to_f * 10 .to_i)
            return "Holdings updated"
        end
    end

    #send the users avalible funds in AUD 
    def self.useravaliblefunds(users_id)
        #Quary Holding table in DB loop over
        Holding.all.each do |holdings|
            if holdings[:owner_users_ID] == users_id
                if holdings[:stock_code] == "AUD"
                    return holdings[:quantity]
                end
            end
        end
    end

    # finalise a trade
    def self.tradeconfirmed(trade_id , purchasing_user_id, quantity)
        quantity = quantity.to_f
        #Quary Holding table in DB for itme with the trade ID
        trade = Holding.find(trade_id)
        @selling_user_id = trade[:owner_users_ID]
        #Quary Holding table in DB loop over all
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
        realtime_stock_value = priceperunitcalc(trade)
        final_cost = (((realtime_stock_value * quantity) * 100).round)/100
        if @purchasing_user_funds > final_cost
            if trade[:quantity] >= quantity
                #Update item in Holding table in DB purchasing_user - AUD
                Holding.where(:id => @purchasing_user_funds_id).update_all(:quantity => @purchasing_user_funds - final_cost)
                #Update item in Holding table in DB selling_user + AUD
                Holding.where(:id => @selling_user_funds_id).update_all(:quantity => @selling_user_funds + final_cost)
                #Update item in Holding table in DB selling_user - quantity
                Holding.where(:id => trade_id).update_all(:quantity => trade[:quantity] - quantity)
                #create item in Holding table in DB purchasing_user stock and quantity
                Holding.create!(owner_users_ID: purchasing_user_id, stock_code: trade[:stock_code], quantity: quantity, asking: 50)
                
                #create item in Transaction table in DB with all the info of the trade
                Transaction.create!(sold_user_id: @selling_user_id, buying_user_id: purchasing_user_id, stock_code: trade[:stock_code], quantity: quantity, price_per_share: realtime_stock_value)

                return "Trade in compleated at a final cost of $#{final_cost}"

            else
                return "Error: Avalible: $#{trade[:quantity]} --- Wanted: $#{quantity}"
            end
        else
            return "Error: Final cost of $#{final_cost} --- Avalible: $#{@purchasing_user_funds}"
        end

    end 

    #get the price per unit factering in asking %
    def self.priceperunitcalc(trade)
        if trade[:asking] < 0            
            lower = true
            per_ammount = (trade[:asking].to_f/10)*-1
        else
            lower = false
            per_ammount = (trade[:asking].to_f/10)
        end
        stock_price = getlivestockprice(trade[:stock_code])
        if lower
            cost = stock_price-((per_ammount/100)*stock_price)
        else
            cost = stock_price+((per_ammount/100)*stock_price)
        end
    end
    
    #get the live stock price
    #if Historical Stock Price is less then 30 min old then just get the Historical Stock Price.
    def self.getlivestockprice(stockcode)
        @price_in_history = 0
        #Quary HistoricalStockPrice table in DB loop over all to see in price info on the requested sock in less then 30 min old 
        HistoricalStockPrice.all.reverse().each do |stock|
            if @price_in_history == 0
                if stock[:stockcode] == stockcode
                    if stock[:created_at] >= DateTime.now - 30.minutes
                        p "!!!! getting price from history"
                        @price = stock[:price]
                        @price_in_history = 1
                    end
                end
            end
        end 
        if @price_in_history == 0
            #if price info on the requested sock in more then 30 min old scrap curect price from morningstar.com.au
            p "!!!! getting price from morningstar.com.au"
            url = "https://www.morningstar.com.au/Stocks/NewsAndQuotes/" + stockcode.to_s
            require 'nokogiri'
            require 'open-uri'
                    doc = Nokogiri::HTML(URI.open(url))     
            docdata = []
            doc.xpath('//span', doc.collect_namespaces).each do |link|
                docdata << link.content
            end
            @price = docdata[18].to_f
            #Create item in HistoricalStockPrice table in DB with updated price.
            updatehistoricalstockprice(stockcode, @price)
        end
        p "!!!! price is #{@price}"
        return @price
    end

    #update the Historical Stock Price
    def self.updatehistoricalstockprice(stockcode, price)
        #Create item in HistoricalStockPrice table in DB with updated price.
        HistoricalStockPrice.create!(stockcode: stockcode, price: price)
    end

    #get the starting stock prises for all of a new users starting stocks.
    def self.getuserstartingstockprises(user)
        array = []
        for i in 1..4
            stock = user[("startingstock#{i}").to_sym]
            array << getlivestockprice(stock)
        end
        return array
    end 
   
end
