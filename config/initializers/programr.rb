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

load_cache

if Rails.env == 'production'
$redis = Redis.new(:host => 'lab.redistogo.com', :port => 9310, :password => 'a1037c09340ffeefc0db340daca02fa1' )
else
$redis = Redis.new(:host => 'localhost', :port => 6379)
end

if $redis.get('my_aiml').blank?
  $redis.set('my_aiml', IO.read('./lib/programr/lib/aiml/my.aiml'))
end

$robot.parser.parse $redis.get('my_aiml')
