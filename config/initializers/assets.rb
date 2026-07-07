# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w(pdf.scss)

# This app doesn't use ActionText (no rich_text fields); it has no
# precompile_assets opt-out flag like ActiveStorage/ActionCable, so remove
# its auto-added JS directly. Same ES6-vs-Uglifier problem as the other two.
# Must happen in after_initialize: ActionText's own engine initializer adds
# these entries, and it runs after this file, re-adding them if subtracted here.
Rails.application.config.after_initialize do
  Rails.application.config.assets.precompile -= %w(actiontext.js actiontext.esm.js trix.js trix.css)
end
