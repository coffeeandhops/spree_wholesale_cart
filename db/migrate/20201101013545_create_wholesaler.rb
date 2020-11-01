class CreateWholesaler < SpreeExtension::Migration[6.0]
  def change
    create_table :spree_wholesalers do |t|
      t.references :user
      t.string :main_contact
      t.string :alternate_contact
      t.string :web_address
      t.string :alternate_email
      t.text   :notes
      t.integer :business_address_id
      t.timestamps
    end
  end
end
