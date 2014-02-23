class TaskFactory

    def initialize(default_load_path)
        @default_task_load_path = default_load_path
    end

    def create_task(task_config, remote)
        begin
            task_classname = task_config['classname']
            path = task_config['path']
            if path.nil? or path.length == 0 then
                path = @default_task_load_path
            end

            task_load_path = '%s/%s' % [path, task_classname]

            require task_load_path            
            task_class = Object.const_get(task_classname)
            task = task_class.new(task_config, remote)
            task
        rescue
            puts 'Cannot load module of %s' % [task_load_path]
        end
    end
end