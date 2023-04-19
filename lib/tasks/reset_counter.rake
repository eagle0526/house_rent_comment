# 這個rake沒用到，因為我用 impressionist 這個插件
namespace :db do
  desc "Reset Counter Cache"
  task :reset_counter => :environment do
    p "prepare to reset counters"
    House.all.each do |house|
        House.reset_counters(house.id, :houses_count)
    end
    p "done"
  end
end