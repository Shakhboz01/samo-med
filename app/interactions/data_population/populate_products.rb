module DataPopulation
  class PopulateProducts < ActiveInteraction::Base
    def execute
      products_data = JSON.parse(File.read('app/assets/javascripts/products.json'))
      product_category = ProductCategory.find_or_create_by(name: 'Смешанные')
      products_data.each do |product_data|
        create_products(product_data, product_category.id)
      end
    end

    private

    def create_products(data, category_id)
      name = data['name']
      initial_remaining = data['amount']
      price_in_usd = true
      buy_price = data['buy_price']

      sell_price = data['buy_price'] * 105 / 100.to_f


      pr = Pack.create(
        name: name,
        code: '',
        product_category_id: category_id,
        price_in_usd: price_in_usd,
        buy_price: buy_price,
        sell_price: sell_price,
        initial_remaining: initial_remaining,
        unit: data['unit'].to_sym
      )
      puts pr.errors.messages
    end
  end
end
