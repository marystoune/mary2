pid "/data/www/qiwicoin.org/unicorn.pid"
stderr_path "/data/www/qiwicoin.org/www/log/unicorn.log"
stdout_path "/data/www/qiwicoin.org/www/log/unicorn.log"
listen "/tmp/unicorn.qiwicoin.sock"
worker_processes 4
timeout 30

# Force the bundler gemfile environment variable to
# # # reference the capistrano "current" symlink
# before_exec do |_|
#   ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
#   end
