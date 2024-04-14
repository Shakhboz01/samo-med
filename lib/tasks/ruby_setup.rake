# lib/tasks/ruby_setup.rake

namespace :ruby do
  desc "Setup Ruby version"
  task :setup do
    ruby_version_file = "/root/.rbenv/version"

    if File.exist?(ruby_version_file)
      File.write(ruby_version_file, "3.1.4")
    else
      sh "rbenv install 3.1.4"
      sh "rbenv global 3.1.4"
    end

    sh "gem install bundler:2.5.9"
  end
end
