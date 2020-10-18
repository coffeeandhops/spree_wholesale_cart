FactoryBot.define do
  factory :wholesale_order, class: Spree::WholesaleOrder do
    transient do
      line_items_count { 150 }
      line_items_quantity { 10 }
      line_items_price { 20.0 }
    end

    order { create(:order) }

    after(:create) do |ws_order, evaluator|
      evaluator.line_items_count.times do
        create(:wholesale_line_item, wholesale_order: ws_order, item_quantity: evaluator.line_items_quantity)
      end
      
      ws_order.wholesale_line_items.reload # to ensure order.line_items is accessible after
    end
  end
end
