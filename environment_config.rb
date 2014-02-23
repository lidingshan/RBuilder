require 'yaml'

class EnvironmentConfig

    def initialize(yaml_file)
        @yaml_config = YAML.load_file(yaml_file)
    end

    def remote_config(env_key)
        @yaml_config[env_key]
    end
end