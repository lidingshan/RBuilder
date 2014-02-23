require 'net/telnet'
require 'yaml'

CURRENT_DIR = File.expand_path File.dirname(__FILE__)
require CURRENT_DIR + '/task_factory'

class BuildHelper
    def initialize(remote, task_factory = nil, build_config = nil)
        @task_chain = []
        
        @remote = remote
        @build_config = build_config

        if task_factory.nil? then
            @factory = TaskFactory.new('task/')
        else
            @factory = task_factory
        end
    end

    def get_task(task_config)
        task = @factory.create_task(task_config, @remote)
        @task_chain.push task
        
        task_dependency = task_config['depends_on']
        if !task_dependency.nil? and task_dependency.length > 0 then
            config = @build_config.get_task_config(task_dependency)
            get_task(config)
        end

        @task_chain
    end

    def execute

        while @task_chain.length > 0 do
            task = @task_chain.pop
            puts
            task.run
        end
    end

end