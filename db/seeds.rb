CurrencyRate.create(rate: 12400.00, finished_at: nil)
ProductCategory.create(name: 'Сервис')
ProductCategory.create(name: 'Аптека', weight: 1)
ProductCategory.create(name: 'Другие', weight: 1)

User.create(name: 'admin', email: 'admin@gmail.com', role: 0, password: 123456)
User.create(name: 'Kassir', email: 'kassir@gmail.com', role: 5, password: 111111)
