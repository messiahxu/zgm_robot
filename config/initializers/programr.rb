require 'programr/lib/programr/facade'
$robot = ProgramR::Facade.new
$robot_last = ProgramR::Facade.new
#$robot.learn ['lib/programr/lib/aiml/aiml']
$robot_last.learn ['lib/programr/lib/aiml/last.aiml']
def load_cache
  begin
    File.open('./lib/programr/lib/cache/init.cache', 'r') do |f|
      cache = Marshal.load(f.read)
      $robot.graph_master.merge cache if cache
    end
  rescue => err
    p err
  end
end
begin
  ActiveRecord::Base.connection.execute 'delete from sessions'
rescue => err
  p err
end

time = Time.now
load_cache
puts "#"*40
cache_log = "load cache use "  + (Time.now - time).round(2).to_s + "s.  "
puts cache_log
if Rails.env == 'production'
$redis = Redis.new(:host => 'lab.redistogo.com', :port => 9310, :password => 'a1037c09340ffeefc0db340daca02fa1' )
else
$redis = Redis.new(:host => 'localhost', :port => 6379)
end
time = Time.now
if $redis.get('my_aiml').blank?
  $redis.set('my_aiml',IO.read('./lib/programr/lib/aiml/my.aiml'))
end
$robot.parser.parse $redis.get('my_aiml')
redis_log = "redis use " + (Time.now - time).round(2).to_s + "s. "
begin
  Logs.new(:log => cache_log + redis_log).save
rescue => err
  puts err
end
