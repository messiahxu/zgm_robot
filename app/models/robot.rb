class Robot < ActiveRecord::Base
  attr_accessible :receive, :reply, :username

  class << self
    def dump
      File.open('lib/programr/lib/cache/init.cache','w') do |file|
        marshal = Marshal.dump($robot.graph_master, -1).force_encoding('utf-8')
        file.write(marshal)
      end
    end

    def learn(pattern, template)
      str = "<category>\n" \
        << "<pattern>" << pattern.upcase << "</pattern>\n" \
        << "<template>\n" \
        << template \
        << "\n</template>\n" \
        << "</category>\n\n" \
        << "</aiml>"

        text = IO.read './lib/programr/lib/aiml/my.aiml'
        text.gsub! '</aiml>', str
      File.open('./lib/programr/lib/aiml/my.aiml','w') do |f|
        f << text
      end
      $robot.parser.parse text
    end
  end

end
