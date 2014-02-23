CURRENT_DIR = File.expand_path File.dirname(__FILE__)

require CURRENT_DIR + '/environment_config'
require CURRENT_DIR + '/remote_server'
require CURRENT_DIR + '/build_helper'
require CURRENT_DIR + '/build_config'
require CURRENT_DIR + '/argument_parser'

def help_message
    puts 'Usage: ruby build.rb -[t|r|config|env]:<argument>'
    puts '-t:<task key>  Required. the task key defined in build configure file'
    puts '-r:<remote server key>  Required. the remote server key defined in environment configure file'
    puts '-config:<build config file path> Required'
    puts '-env:<environment config file path> Required'

    exit
end

begin
    if ARGV.length == 0 then
        help_message
    end

    arg_parser = ArgumentParser.new(ARGV)

    task_key = arg_parser.arg_values['t']
    if task_key.nil? then
        help_message
        exit
    end

    remote_server_index = arg_parser.arg_values['r']
    if remote_server_index.nil? then
        help_message
        exit
    end

    build_config_file = arg_parser.arg_values['config']
    if build_config_file.nil? then
        help_message 
        exit
    end

    env_config_file = arg_parser.arg_values['env']
    if env_config_file.nil? then        
        help_message
        exit
    end

    build_config = BuildConfig.new(build_config_file)
    task_config = build_config.get_task_config(task_key)

    env_config = EnvironmentConfig.new(env_config_file)
    remote_config = env_config.remote_config(remote_server_index)
    remote_server = RemoteServer.new(remote_config)

    default_task_load_path = CURRENT_DIR + '/task'
    task_factory = TaskFactory.new(default_task_load_path)
    build_helper = BuildHelper.new(remote_server, task_factory, build_config)

    puts 'Automate build is started...'
    puts '-------------------------------------------------------------------------------'
    
    build_helper.get_task(task_config)
    build_helper.execute

    puts
    puts '-------------------------------------------------------------------------------'
    puts 'Build is Successful'

    remote_server.close
rescue Exception => e
    puts
    puts e
    puts '-------------------------------------------------------------------------------'
    puts 'Build is Failed'

    remote_server.close    
end