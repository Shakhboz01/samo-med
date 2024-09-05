module DataPopulation
  class PopulateProducts < ActiveInteraction::Base
    def execute
      products_data = JSON.parse(File.read('app/assets/javascripts/products.json'))
      products_data.each do |product_data|
        create_products(product_data)
      end
    end

    private

    def create_products(data)
      name = data['XIZMAT_NOMI']
      initial_remaining = 100
      price_in_usd = false
      buy_price = data['NARXI']
      sell_price = data['NARXI']

      pr = Pack.create(
        name: name,
        code: '',
        product_category: ProductCategory.find_or_create_by(name: data['PAPKA_NOMI']),
        price_in_usd: price_in_usd,
        buy_price: buy_price,
        sell_price: sell_price,
        initial_remaining: initial_remaining,
      )
      puts pr.errors.messages
    end
  end
end
