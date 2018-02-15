class CreateGemfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :gemfiles do |t|
      t.attachment :file

      t.timestamps
    end
  end
end
