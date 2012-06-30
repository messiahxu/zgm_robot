module ProgramR
  class History
    @@topic      = 'default'
    @@inputs     = []
    @@responses  = []
    @@starGreedy = []
    @@thatGreedy = []
    @@topicGreedy = []

    def topic; @@topic end

    def that
      return 'undef' unless @@responses[0]
      @@responses[0] 
    end

    def justbeforethat 
      return 'undef' unless @@responses[1]
      @@responses[1] 
    end

    def justthat 
      return 'undef' unless @@inputs[0]
      @@inputs[0] 
    end

    def beforethat 
      return 'undef' unless @@inputs[1]
      @@inputs[1] 
    end

    def getStar(anIndex) 
      return 'undef' unless @@starGreedy[anIndex]
      @@starGreedy[anIndex].join(' ') 
    end

    def getThatStar(anIndex) 
      return 'undef' unless @@thatGreedy[anIndex]
      @@thatGreedy[anIndex].join(' ') 
    end

    def getTopicStar(anIndex) 
      return 'undef' unless @@topicGreedy[anIndex]
      @@topicGreedy[anIndex].join(' ') 
    end

    def updateTopic(aTopic)
      @@topic = aTopic
    end

    def updateResponse(aResponse)
      @@responses.unshift(aResponse)
    end

    def updateStimula(aStimula)
      @@inputs.unshift(aStimula)
    end

    def getStimula(anIndex)
      @@inputs[anIndex]
    end

    def updateStarMatches(aStarGreedyArray)
      @@starGreedy = []
      @@thatGreedy = []
      @@topicGreedy = []
      currentGreedy = @@starGreedy
      aStarGreedyArray.each do |greedy|
        if(greedy == '<that>')
          currentGreedy = @@thatGreedy
        elsif(greedy == '<topic>')
          currentGreedy = @@topicGreedy
        elsif(greedy == '<newMatch>')
          currentGreedy.push([])
        else
          currentGreedy[-1].push(greedy)
        end
      end
    end


    def self.loading file
      File.open(file,'r') do |f|
        array=Marshal.load(f.read)
        @@topic=array[0]
        @@inputs=array[1]
        @@responses=array[2]
        @@startGreed=array[3]
        @@thatGreed=array[4]
        @@topicGreedy=array[5]
        Environment.set_readOnlyTags=array[6]
      end rescue nil
    end

    def self.save_to_session
      array = Array.new
      array<<@@topic<<@@inputs<<@@responses<<@@starGreedy<<@@thatGreedy<<@@topicGreedy<<Environment.get_readOnlyTags
    end

    def self.get_from_session array
      @@topic=array[0]
      @@inputs=array[1]
      @@responses=array[2]
      @@startGreed=array[3]
      @@thatGreed=array[4]
      @@topicGreedy=array[5]
      Environment.set_readOnlyTags=array[6]
    end

    def self.saving file
      File.open(file,'w') do |f|
        str=Marshal.dump([]<<@@topic<<@@inputs<<@@responses<<@@starGreedy<<@@thatGreedy<<@@topicGreedy<<Environment.get_readOnlyTags ,-1)
        str.force_encoding('utf-8').encode
        f.write(str)
      end
    end

    def self.init
      @@topic='default'
      @@inputs=[]
      @@responses=[]
      @@starGreedy=[]
      @@thatGreedy=[]
      @@topicGreedy=[]
      Environment.set_readOnlyTags=YAML::load(
        File.open(
          File.dirname(__FILE__) +
                        "/../../conf/readOnlyTags.yaml"))
    end

  end
end

