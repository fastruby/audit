class AddAlphaIdToGemfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :gemfiles, :alpha_id, :string, unique: true
  end
end
