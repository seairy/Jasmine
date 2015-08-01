namespace :data do
  desc 'Cleanup all data.'
  task :reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Fill database with fake data'
  task :populate => :environment do |t, args|
    bench = Benchmark.measure do
      100.times do
        user = User.faker
        user.update!(phone: "1#{Faker::PhoneNumber.subscriber_number(10)}", nickname: Faker::Name.name, portrait: fake_image_file, created_at: Time.now - rand(2..365).days)
        user.active!
        user.behaviors.sign_up!
        rand(2..4).times do
          task = user.demanded_tasks.create!(content: Faker::Lorem.paragraph(rand(2..8)), region_id: Region.all.sample.id, estimate_price: rand(200..26000), created_at: Time.now - rand(60..86400).seconds)
          rand(0..4).times do
            task.photographs.create!(file: fake_image_file)
          end
          task.pay_deposit!
        end
      end
    end
    p "finished in #{bench.real} second(s)"
  end

  def fake_image_file
    abstract_image_filename = File.open(File.join(Rails.root, 'public', 'abstract_images', "#{rand(1..995).to_s.rjust(3, '0')}.jpg"))
  end
end