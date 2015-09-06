namespace :data do
  desc 'Cleanup all data.'
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    FileUtils.rm_r File.join(Rails.root, 'public', 'uploads')
  end

  desc 'Fill database with fake data'
  task :populate => :environment do |t, args|
    bench = Benchmark.measure do
      10.times do
        user = User.faker
        user.update!(phone: "1#{Faker::PhoneNumber.subscriber_number(10)}", nickname: Faker::Name.name, portrait: fake_image_file, created_at: Time.now - rand(2..365).days)
        user.active!
        user.behaviors.sign_up!
        rand(2..4).times do
          task = user.demanded_tasks.create!(content: Faker::Lorem.paragraph(rand(2..8)), category_id: Category.all.sample.id, region_id: Region.all.sample.id, consignee_name: Faker::Name.name, consignee_phone: "1#{Faker::PhoneNumber.subscriber_number(10)}", consignee_address: "#{Faker::Address.city} #{Faker::Address.street_name} #{Faker::Address.street_address}", consignee_postal_code: Faker::Address.zip_code, estimate_unit_price: rand(200..26000), quantity: rand(1..3), created_at: Time.now - rand(5..15).days - rand(60..86400).seconds)
          rand(0..4).times do
            task.photographs.create!(file: fake_image_file)
          end
          task.pay_deposit!
        end
      end
      demo_tasks = [
        { category: '食品保健', content: '白色恋人饼干，要浅色口味的', region: '日本', quantity: 2, estimate_unit_price: 60 },
        { category: '家居日常', content: '求日本代购眼药水，带隐形眼镜时可用，品牌不限，单瓶价格50—100之间均可接受', region: '日本', quantity: 1, estimate_unit_price: 100 },
        { category: '服装箱包', content: '求代购AF女款连帽衫，1件，浅蓝最好，深蓝也可，价格400—500间可接受。款式参考如图，希望是胸前有字母的款。', region: '美国', quantity: 1, estimate_unit_price: 500 },
        { category: '服装箱包', content: 'UGG "Bailey Button Triplet" 三扣高筒雪地靴，紫色，7码，1双，1700内接受。', region: '其它', quantity: 1, estimate_unit_price: 1700 },
        { category: '科技电子', content: '求代美版苹果6S, 64G,粉红色,2个，多少钱都要', region: '美国', quantity: 2, estimate_unit_price: 20000 },
        { category: '科技电子', content: 'JBL GO 音乐金砖无线蓝牙音响户外迷你小音箱,粉红色', region: '其它', quantity: 1, estimate_unit_price: 300 },
        { category: '服装箱包', content: '罗意威 LOEWE HOBO SMALL 牛皮单肩手提女包 334 30 L44，1个，一万以内接受，需提供代购小票及完整包装，送人', region: '其它', quantity: 1, estimate_unit_price: 10000 },
        { category: '食品保健', content: '澳洲swisse液体胶原蛋白，液体，4瓶，单瓶190可接受', region: '其它', quantity: 4, estimate_unit_price: 190 },
        { category: '母婴玩具', content: '求日代花王纸尿裤，M码，6包', region: '日本', quantity: 6, estimate_unit_price: 180 },
        { category: '个护化妆', content: '海蓝之谜浓缩修护眼部精华霜15ml全效眼霜', region: '其它', quantity: 1, estimate_unit_price: 1700 },
        { category: '服装箱包', content: '积家Jaeger男表，大师系列机械男表1418430', region: '日本', quantity: 2, estimate_unit_price: 60 },
        { category: '服装箱包', content: '美国ck 简约光面超薄款内衣F3778 ，75B，一件，230以下接受', region: '美国', quantity: 1, estimate_unit_price: 230 },
        { category: '服装箱包', content: 'prada男款polo衫，短袖，身高150，体重145，肩宽45，正常L码，这款如果偏大，可买M码', region: '其它', quantity: 1, estimate_unit_price: 1200 },
        { category: '服装箱包', content: '韩国代购MCM铆钉款腰带', region: '韩国', quantity: 1, estimate_unit_price: 700 },
        { category: '服装箱包', content: '施华洛世奇水晶项链，款式如图', region: '其它', quantity: 1, estimate_unit_price: 800 }
      ]
      demo_tasks.each_with_index do |demo_task, i|
        task = User.all.sample.demanded_tasks.create!(content: demo_task[:content], category: Category.where(name: demo_task[:category]).first, region: Region.where(name: demo_task[:region]).first, consignee_name: Faker::Name.name, consignee_phone: "1#{Faker::PhoneNumber.subscriber_number(10)}", consignee_address: "#{Faker::Address.city} #{Faker::Address.street_name} #{Faker::Address.street_address}", consignee_postal_code: Faker::Address.zip_code, estimate_unit_price: demo_task[:estimate_unit_price], quantity: demo_task[:quantity], created_at: Time.now - rand(60..86400).seconds)
        image_name = "#{(i + 1).to_s.rjust(2, '0')}.jpg"
        begin
          image_file = File.open(File.join(Rails.root, 'public', 'demo_tasks', image_name))
          task.photographs.create!(file: image_file)
        rescue

        end
        task.pay_deposit!
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  def fake_image_file
    abstract_image_filename = File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..995).to_s.rjust(3, '0')}.jpg"))
  end
end