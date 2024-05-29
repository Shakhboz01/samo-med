CurrencyRate.create(rate: 12400.00, finished_at: nil)
zeros = ProductCategory.create(name: 'Склад')
first = ProductCategory.create(name: 'Паразиталогия', weight: 1)
second = ProductCategory.create(name: 'Дневная процедура', weight: 1)
third = ProductCategory.create(name: 'Хиджама', weight: 1)
fourth = ProductCategory.create(name: 'Зулуг', weight: 1)
fifth = ProductCategory.create(name: 'Массаж', weight: 2)
sixth = ProductCategory.create(name: 'Массаж для детей', weight: 3)
seventh = ProductCategory.create(name: 'Сервис', weight: 1)


Pack.create(name: 'Xijoma banka', buy_price: 3000, sell_price: 6000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Malham', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Nakaneshnik', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Sariq maz', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Qora maz', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Zaytun yog\'', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Xlor', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Qo\'shimcha giyohlar', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Klizmaga giyoh', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Skalper', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'Sok', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'salfetka', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'bumaga', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'qoshiqcha', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'stakan', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'perchatka', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'vazelin', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)
Pack.create(name: 'trubochka', buy_price: 0, sell_price: 5000, initial_remaining: 0, product_category: zeros)



Pack.create(name: 'Laboratoriya tekshiruv', buy_price: 0, sell_price: 40000, initial_remaining: 0, product_category: first)
Pack.create(name: 'Laboratoriya kunlik', buy_price: 0, sell_price: 125000, initial_remaining: 0, product_category: first)
Pack.create(name: 'Tozalov klizma', buy_price: 0, sell_price: 25000, initial_remaining: 0, product_category: first)

Pack.create(name: 'Kapel\'nitsa', buy_price: 0, sell_price: 20000, initial_remaining: 0, product_category: second)
Pack.create(name: 'Ukol', buy_price: 0, sell_price: 10000, initial_remaining: 0, product_category: second)
Pack.create(name: 'Ukol strey', buy_price: 0, sell_price: 10000, initial_remaining: 0, product_category: second)

Pack.create(name: 'Xijoma', buy_price: 3000, sell_price: 6000, initial_remaining: 0, product_category: third)

Pack.create(name: 'Baku', buy_price: 0, sell_price: 25000, initial_remaining: 0, product_category: fourth)
Pack.create(name: 'Eron', buy_price: 0, sell_price: 15000, initial_remaining: 0, product_category: fourth)

Pack.create(name: 'Massaj umumiy', buy_price: 0, sell_price: 180000, initial_remaining: 0, product_category: fifth)
Pack.create(name: 'Massaj osteoxondroz', buy_price: 0, sell_price: 180000, initial_remaining: 0, product_category: fifth)
Pack.create(name: 'Massaj qo\'l-oyoq', buy_price: 0, sell_price: 180000, initial_remaining: 0, product_category: fifth)

Pack.create(name: 'Massaj umumiy(bolalarga)', buy_price: 0, sell_price: 40000, initial_remaining: 0, product_category: sixth)
Pack.create(name: 'Massaj qo\'l-oyoq(bolalarga)', buy_price: 0, sell_price: 40000, initial_remaining: 0, product_category: sixth)

Pack.create(name: 'Vrach ko\'rigi', buy_price: 0, sell_price: 50000, initial_remaining: 0, product_category: seventh)
Pack.create(name: 'EKG', buy_price: 0, sell_price: 50000, initial_remaining: 0, product_category: seventh)
Pack.create(name: 'Gidrovanna', buy_price: 0, sell_price: 100000, initial_remaining: 0, product_category: seventh)


User.create(name: 'Admin', email: 'admin@gmail.com', role: 0, password: 111111)
