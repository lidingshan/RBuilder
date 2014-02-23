require 'yaml'

class BuildConfig
    def initialize(config_file)
        @build_config = YAML.load_file(config_file)
    end

    def get_task_config(task_name)
        @build_config[task_name]
    end
end