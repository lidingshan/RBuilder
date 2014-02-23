require 'net/telnet'

class RemoteServer
    attr_reader :hostname, :login_id, :password, :login_prompt, :password_prompt
    attr_reader :terminal_prompt, :source_copy_to, :test_copy_to, :source_root, :test_root, :test_execution_home
    attr_reader :JBUNIT_HOME, :config

    def initialize(config)
        @config = config

        @hostname = config['hostname']

        user_name = config['username']

        if config['login_id'].nil? or config['login_id'].length == 0 then
            @login_id = user_name
        else
            @login_id = config['login_id'].gsub('{username}', user_name)
        end

        @password = config['password']
        @login_prompt = config['login_prompt']
        @password_prompt = config['password_prompt']
        @terminal_prompt = config['terminal_prompt'].gsub('{username}', user_name)
        @source_copy_to = config['source_copy_to'].gsub('{hostname}', @hostname)
        @test_copy_to = config['test_copy_to'].gsub('{hostname}', @hostname)
        @source_root = config['source_root']
        @test_root = config['test_root']
        @test_execution_home = config['test_execution_home']
        @JBUNIT_HOME = config['JBUNIT_HOME']

        @remote_host = Net::Telnet::new(
            "Host" => @hostname,
            "Prompt" => /#{@terminal_prompt}/
        )

    end

    def login
        @remote_host.login({
            "Name" => @login_id,
            "Password" => @password,
            "LoginPrompt" => /[#{@login_prompt}]/,
            "PasswordPrompt" => /[#{@password_prompt}]/
        })
    end

    def execute(cmd)
        response = ''
        @remote_host.cmd(cmd) { |c| 
            response += c
            if response.match(/(jBASE debugger->)/) then
                puts 'Found debugger prompt...'
                @remote_host.puts('Q')
                @remote_host.puts('Y')
            end
        }

        response
    end

    def logoff
        @remote_host.puts('LO')
    end

    def close
        logoff
        @remote_host.close
    end
end