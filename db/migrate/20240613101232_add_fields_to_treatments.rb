class AddFieldsToTreatments < ActiveRecord::Migration[7.0]
  def change
    add_column :treatments, :bosh_ogriq, :boolean, default: false
    add_column :treatments, :qon_bosimi_kotarilishi, :boolean, default: false
    add_column :treatments, :holsizlik, :boolean, default: false
    add_column :treatments, :bel_va_oyoq_ogriqi, :boolean, default: false
    add_column :treatments, :gejga_tolishi, :boolean, default: false
    add_column :treatments, :teri_kasalliklari, :boolean, default: false
    add_column :treatments, :koz_kasalliklari, :boolean, default: false
    add_column :treatments, :jkt_kasalliklari, :boolean, default: false
    add_column :treatments, :boshqa_shikoyatlar, :boolean, default: false

    add_column :treatments, :tish_gijirlashi, :boolean, default: false
    add_column :treatments, :jirrakilik, :boolean, default: false
    add_column :treatments, :orqa_qichishishi, :boolean, default: false
    add_column :treatments, :toshma_va_doglar, :boolean, default: false
    add_column :treatments, :ishtaxasizlik, :boolean, default: false
    add_column :treatments, :boy_osmaslik, :boolean, default: false
    add_column :treatments, :oyoq_ogrigi, :boolean, default: false
    add_column :treatments, :siyib_qoyish, :boolean, default: false
  end
end
