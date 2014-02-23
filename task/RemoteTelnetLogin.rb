CURRENT_DIR = File.expand_path File.dirname(__FILE__)

require CURRENT_DIR + '/../task'

class RemoteTelnetLogin < Task
    def initialize(task_config, remote)
        @remote = remote
        @description = task_config['description']
    end

    def run
        puts @description
        begin
            @remote.login
        rescue Exception => e
            puts e            
        end
    end
end