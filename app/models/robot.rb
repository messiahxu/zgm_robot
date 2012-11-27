class Robot < ActiveRecord::Base
  attr_accessible :receive, :reply, :username, :status

  NullReply = 'You gotta say something.'
  ChineseReply = BingTranslator.new('zhouguangming-demo-1', 'zn6IANEDWGWa7+VCvS5tBrlIGK21EU+OfU/4QgLyVQU=')

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
      text = "<aiml>\n" + str
      $robot.parser.parse text
      $redis.set('my_aiml', $redis.get('my_aiml').gsub!('</aiml>', str))
    end

    def reply receive
      turn receive

      if receive =~ /[\u4e00-\u9fa5]/
        @receive_chinese = receive
        need_transalation = true
        receive = ChineseReply.translate receive, :from => 'zh-chs', :to => 'en'
      end

      status = 0
      if receive.blank?
        reply = NullReply
      else
        reply = $robot.get_reaction receive
        if reply.blank?
          reply = get_reply_from_wiki receive
        end
        if reply.blank?
          reply = $robot_last.get_reaction receive
        else
          status = 1
        end
      end
      if Robot.count > 9995
        Robot.delete_all
      end

      if @receive_chinese
        reply = ChineseReply.translate reply, :from => 'en', :to => 'zh-chs'
        receive = @receive_chinese
      end

      Robot.create(:username => ProgramR::Environment.get_readOnlyTags['name'],
                   :receive=>receive,
                   :reply=>reply,
                   :status => status)

      reply
    end

    def get_reply_from_wiki receive
      wiki_word = Crawler.get_wiki_word(receive)
      reply = Crawler.find_in_wiki wiki_word
    end

    def turn receive
      receive.gsub! /what\'s/, "what is"
      receive.gsub! /whats/, "what is"
      receive.gsub! /whos/, "who is"
      receive.gsub! /who\'s/, "who is"
      receive.gsub! /that\'s/, "that is"
      receive.gsub! /this\'s/, "this is"
      receive.gsub! /it\'s/, "it is"
      receive.gsub! /we\'re/, "we are"
      receive.gsub! /you\'re/, "you are"
      receive.gsub! /they\'re/, "they are"
      receive.gsub! /i\'m/, "i am"
      receive.gsub! /she\'s/, "she is"
      receive.gsub! /he\'s/, "he is"
      receive.gsub! /don\'t/, "do not"
      receive.gsub! /dont/, "do not"
      receive.gsub! /didn\'t/, "did not"
      receive.gsub! /didnt/, "did not"
      receive.gsub! /doesn\'t/, "does not"
      receive.gsub! /doesnt/, "does not"
      receive.gsub! /aren\'t/, "are not"
      receive.gsub! /isn\'t/, "is not"
      receive.gsub! /\s+u\s+/, " you "
      receive.gsub! /\s+r\s+/, " are "
      receive.gsub! /\s+ur\s+/, " your "
      receive.gsub! /\s+u$/, " you "
      receive.gsub! /\s+r$/, " are "
      receive.gsub! /\s+cus\s+/, " because "
      receive.gsub! /haven\'t/, " have not "
      receive.gsub! /can\'t/, " can not "
    end

  end
end
