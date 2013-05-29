namespace :order do
  desc "Cancel expired orders"
  task :cancel_expired => :environment do
    puts "Start to cancel orders expired before #{Time.now}"
    Order.cancel_expired!
  end
end
