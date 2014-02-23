CURRENT_DIR = File.expand_path File.dirname(__FILE__)

require CURRENT_DIR + '/../task'

class XCopyTask < Task
    attr_reader :source, :destination, :description

    def initialize(task_config, remote)
        @name = "xcopy"

        @remote = remote        

        @description = task_config['description']
        @source = get_path(task_config['source'])
        @destination = get_path(task_config['destination'])
    end

    def run
        puts @description 

        src = @source.clone
        src = src.gsub('/', '\\')

        dest = @destination.clone
        dest = dest.gsub('/', '\\')

        xcopy_cmd = 'xcopy %s %s /S /Y' % [src, dest]
        puts xcopy_cmd

        is_success = system(xcopy_cmd)
        if !is_success then
            raise 'Error: %s failed' % [xcopy_cmd]
        end

        is_success
    end

    private
    def get_path(path_config)
        path = path_config

        config_key_name = path_config[/^{environment::remote::((.)+)}$/, 1]
        if !config_key_name.nil? then
            path = @remote.send(config_key_name)
        end

        path = path.gsub('{hostname}', @remote.hostname)
        path
    end    
end