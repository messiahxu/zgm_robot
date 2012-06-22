require 'programr/lib/programr/facade'
$robot = ProgramR::Facade.new
$robot_last = ProgramR::Facade.new
#$robot.learn ['lib/programr/lib/aiml/aiml']
$robot.learn ['lib/programr/lib/aiml/my.aiml']
$robot_last.learn ['lib/programr/lib/aiml/last.aiml']
$user_count = 0
begin
  File.open('./lib/programr/lib/cache/init.cache','r') do |f|
    puts '===start load cache==='
    cache = Marshal.load(f.read)
    print('[')
    10.times do |n|
      sleep(0.01)
      print('###')
    end
    print(']  100%'+"\n")
    $robot.graph_master.merge cache if cache
    puts '===load success==='
  end
rescue=>err
  p err
end
