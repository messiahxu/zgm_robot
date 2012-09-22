class Crawler
  TimeoutReply = 'Sorry, try it later please.'
  class << self
    def get_wiki_word(receive)
      pre_word = receive.scan(/(.*do\s+you\s+know\s+)|(.*what\'s\s+a\s+)|(.*what\s+is\s+a\s+)|(.*what\'s\s+the\s+)|(.*what\s+is\s+the\s+)|(.*what\s+is\s+)|(.*what\s*\'s\s+)|(.*who\s+is\s+)|(.*who\s*\'s\s+)/)
      pre_word = pre_word.flatten.compact.join
      receive = receive.gsub(pre_word, '')
      receive[0] = receive[0].upcase
      receive = receive.gsub(/\s+/, '_')
    end

    def find_in_wiki receive
      reply = Wiki.find_by_receive(receive).try(:reply)
      if reply.blank?
        begin
          timeout(3) do |e|
            reply = find_in_wiki_func(receive)
          end
          if reply.present?
            unless Wiki.create(:receive => receive, :reply => reply)
              p 'save error'
            end
          end
          return reply
        rescue=>err
          p err.to_s
          if err.to_s =~ /execution expired/
            return false
          end
        end
      else
        return reply
      end
    end

    def find_in_wiki_func receive
      begin
        @agent = Mechanize.new
        @agent.user_agent_alias = 'Mac Safari'
        receive.gsub!(/\s/, '_')
        url = "http://en.wikipedia.org/wiki/#{receive}"
        puts "\n url=>"+url+"\n"
        page = @agent.get(url)
        div = page.search('#mw-content-text')

        #info box
        div.search('div').remove.search('table').remove
        if div.search('p').first
          content = div.search('p').first.text
        else
          return '404'
        end
        if content =~ /may refer to/
          content = 'Do you mean :<br/> <br/>'
          a = 0
          div.search('ul').each do |ul|
            ul.search('li').each do |v|
              content += (a = a+1).to_s + '.' + '&nbsp; &nbsp;' + '<b>' + v.search('a').text + '</b>'
              v.search('a').remove
              content +='&nbsp;&nbsp;' +  v.text + '</br>'
            end
          end
          return content.gsub(/\[\d+\]/,'')
        else
          content = ''
          infobox = div.search('p').first
          while infobox != nil && infobox.name != 'h2'
            if infobox.name == 'text'
              content += "<br/> <br/> &nbsp; &nbsp;"
            else
              content += infobox.text
            end
          infobox = infobox.next
          end
          return content.gsub(/\[\d+\]/, '')
        end
      rescue => err
        p err.to_s
        if err.to_s =~ /404/
          return false
        end
        return false
      end
    end
  end
end
