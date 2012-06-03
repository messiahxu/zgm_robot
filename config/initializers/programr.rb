require 'programr/lib/programr/facade'
$robot = ProgramR::Facade.new
$robot.learn ['/lib/aiml']
File.open('./lib/programr/lib/cache/init.cache','r') do |f|
    puts '===start load cache==='
    cache = Marshal.load(f.read)
    $robot.graph_master.merge cache if cache
    puts '===load success==='
end

