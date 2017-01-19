require 'faker'

desc 'Populate posts in DB using `create` endpoint'
task populate: :environment do
  names = 100.times.inject([]) { |m| m << Faker::Name.name }
  ips   = 50.times.inject([]) { |m| m << Faker::Internet.ip_v4_address }
  threads = []
  uri = URI.parse('http://localhost:3000/posts')

  10.times do |group|
    threads << Thread.new do
      20_000.times do |i|
        post = {
          'post' => {
            'title' => ['title', group, i].join('-'),
            'body' => ['body', group, i].join('-'),
            'user' => names.sample,
            'user_ip_address' => ips.sample,
            'rating' => rand < 0.7 ? rand(5) : nil
          }
        }

        Net::HTTP.post(uri, post.to_param)
      end
    end
  end

  threads.map(&:join)
end
