require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm
  class RmilkRunner
    def auth
      puts ENV["RTM_FROB"]
      puts ENV["RTM_AUTH_TOKEN"]
      
      if !ENV["RTM_FROB"] != 'stub' || !ENV["RTM_AUTH_TOKEN"] != 'stub'
        frob, auth_url = Rufus::RTM.auth_get_frob_and_url
        puts "It is your first time of using Rmilk so we need to authorize you"
        puts "please visit this URL with your browser and then press 'Enter':"
        puts "#{auth_url}"

        STDIN.gets
        auth_token = Rufus::RTM.auth_get_token(frob)
        puts "\nAfter getting your auth token you must do:"
        puts "export RTM_FROB=#{frob}"
        puts "export RTM_AUTH_TOKEN=#{auth_token}"
      end
    end

    def init_environment
      ENV["RTM_API_KEY"] = "4486f9224a4a8fa8fef850482fc26160"
      ENV["RTM_SHARED_SECRET"] = "03b3b6dba031d1b2"

      ENV["DEFAULT_LIST"] = "Next"
      ENV["NEXT_ACTIONS"] = "Next"
    end

    def init_storage
      @storage = ContextStorage.new('/tmp/rtm_local.store')
    end

    def init_ui
      @ui = ConsoleUi.new(@storage, OutputFormatter.new)
    end

    def process(str)
      puts @ui.process(str) 
    end
  end
end