
CURRENT_DIR = File.expand_path File.dirname(__FILE__)

require CURRENT_DIR + '/../task'

class ExecuteJBUnitTest < Task

    def initialize(task_config, remote)
        @remote = remote
        @description = task_config['description']
        @jbunit_home = get_path(task_config['remote_jbunit_home'])
        @test_root = get_path(task_config['remote_test_root'])
    end

    def run
        puts @description
        cmd = 'set JBUNIT_HOME=%s' % [@jbunit_home]
        @remote.execute(cmd)

        cmd = get_test_exeuction_command
        result = @remote.execute(cmd)
        puts result

        failed_count = result[/Failed\: ((.)+)/, 1]

        if failed_count.nil? or failed_count.to_i > 0 then
            raise 'Error: Test failed'
        end
    end

    def get_test_exeuction_command
        command = 'JBUNIT.MAIN %s' % [@test_root]
        command
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