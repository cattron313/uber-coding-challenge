# Asset filtered out and will not be served so the following is necessary.
# Filtering out assets by removing require tree
Rails.application.config.assets.precompile += %w( home.css )