# Helper methods defined here can be accessed in any controller or view in the application
require 'csv'

module Nuuvem
  class App
    module MainHelper
      def normalize_and_save(csv)
        sum = 0
        CSV.open(csv, "r", {:col_sep => "\t"}).each_with_index do |csv_row, index|
          if index == 0
            next
          else
            begin
              csv_purchaser = csv_row[0].split(' ')     #[0] - name, [1] - surname
              csv_address = csv_row[4].split(' ')       #[0] - number, [1] - name, [2] - type
              csv_item = csv_row[1]                     #description
              csv_item_price = csv_row[2]               #price
              csv_merchant = csv_row[5]                 #name
              csv_sale = csv_row[3]                     #count

              purchaser = Purchaser.find_by(name: csv_purchaser[0], surname: csv_purchaser[1])
              address = Address.find_by(number: csv_address[0], name: csv_address[1], type_place: csv_address[2])
              item = Item.find_by(description: csv_item, price: csv_item_price)
              merchant = Merchant.find_by(name: csv_merchant)

              if purchaser.nil?
                purchaser = Purchaser.new
                purchaser.name = csv_purchaser[0]
                purchaser.surname = csv_purchaser[1]
                purchaser.save!
              end

              if merchant.nil?
                merchant = Merchant.new
                merchant.name = csv_merchant
                merchant.save!
              end

              if address.nil?
                address = Address.new
                address.number = csv_address[0]
                address.name = csv_address[1]
                address.type_place = csv_address[2]
                address.merchant_id = merchant.id
                address.save!
              end

              if item.nil?
                item = Item.new
                item.description = csv_item
                item.price = csv_item_price
                item.merchant_id = merchant.id
                item.save!
              end

              sale = Sale.new
              sale.count = csv_sale
              sale.total = item.price * sale.count
              sale.merchant_id = merchant.id
              sale.purchaser_id = purchaser.id
              sale.item_id = item.id

              sale.save!

              sum += sale.total
            rescue StandardError => e
              ap e
            end
          end

        end
        return sum
      end

    end

    helpers MainHelper
  end
end
