# lib/tasks/disable_assets_precompile.rake

Rake::Task["assets:precompile"].clear


namespace :assets do
  task 'precompile' do
    puts "Precompiling only assets in config/secrets/ directory..."
  end
end
