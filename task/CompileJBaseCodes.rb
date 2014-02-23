CURRENT_DIR = File.expand_path File.dirname(__FILE__)
require CURRENT_DIR + '/../task'

class CompileJBaseCodes < Task
    def initialize(task_config, remote)
        @remote = remote
        @description = task_config['description']
        @sourcecode_path = task_config['sourcecode_path']
        @remote_source_root = get_path(task_config['remote_source_root'])
        @skip_files = task_config['skip_files']        
    end

    def run
        puts @description

        files = []
        root = @sourcecode_path + '/'

        get_files(root, nil, files)

        ret = @remote.execute('LREM')
        puts ret
        
        files.each { |file|
            compile_file file, @remote_source_root
        }
        
    end

    def get_files(root, relative_path, return_files)
        src_path = root
        if !relative_path.nil? and relative_path.length > 0 then
            src_path += relative_path + "/"        
        end

        Dir[src_path + '*'].each{ |f|
            if (File.directory?(f)) then
                relative_path = f.sub(/#{root}/, '')
                get_files(root, relative_path, return_files)
            else
                return_files << f.sub(/#{root}/, '')
            end
        }
    end

    def get_compile_command(file_path, remote_root)       
        filename = file_path[/[^\/]*$/]

        if !@skip_files.nil? and @skip_files.include?(filename) then
            return nil
        end

        path = ''
        if file_path.length > filename.length then
            lenght_exclude_last_slash = file_path.length - filename.length - 2
            path = file_path[0..lenght_exclude_last_slash].gsub('\/', '\\')
            compile_command = 'EB.COMPILE %s\\%s %s' % [remote_root, path, filename]
        else       
            compile_command = 'EB.COMPILE %s %s' % [remote_root, filename]        
        end

        compile_command
    end

    def compile_file(file, remote_root)
        cmd = get_compile_command(file, remote_root)
        if cmd.nil? then
            return
        end

        puts cmd

        result = @remote.execute(cmd)

        if check_compile_result(result) then
            puts 'Build %s successfully' % [file]
        else
            puts result
            raise "Error: Build %s failed" % [file]
        end 
    end

    def check_compile_result(result)
        if result.match(/(.)*(Source file (.)+ compiled successfully)(.)*/)
            true
        else
            false
        end 
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