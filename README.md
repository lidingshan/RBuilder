### What is RBuilder
RBuilder is a DIY utility by using Ruby to execute build tasks automatically. For example:

- Copy the source code files to a specified environment
- Compile the source codes on the environment
- Run tests
- Check if the build is success or not 

### How to use it

- Copy RBuilder to your machine, for example, C:\RBuilder
- Copy build.yml and environment.yml to the folder of souce codes that need to be build
- Config environment.yml to include different remote target server information follow the instrudction of the file
- Config build.yml to include the tasks that need to be involved in the build
- trigger build with the following command:

        ruby C:\RBuilder\build.rb -t:execute_test -r:dev035 -env:environment.yml -config:build.yml
            t:5<task key>  Required. the task key defined in build configure file
            r:<remote server key>  Required. the remote server key defined in environment configure file
            config:<build config file path> Required
            env:<environment config file path> Required


### Add New Build Task
You can create new build task on necessary. To create a new task

1. Under <RBuilder Folder>\task create a new ruby file with the name of the task, e.g. MyBuildTask.rb, what will get a configured parameter from task configuration in build.yml file as a command that need to be exeucted on remote server
2. Edit MyBuildTask.rb like bellow. Make sure the class name is same with file name


        CURRENT_DIR = File.expand_path File.dirname(__FILE__)
        require CURRENT_DIR + '/../task' 
        class MyBuild < Task
            def initialize(task_config, remote)
                @task_param1 = task_config['param1']
                @remote = remote
            end
            def run
                @remote.execute(@task_param1)
            end
        end

3. Configure build.yml for the new task. Like bellow

        my_task:
            description: "My build task" # the task description 
            depends_on: compile_codes # the dependent task of this task what needs to be exeucted successfully in advance
            classname: MyBuildTask # The class name of the task
            param1: dir # parameter configuration which will be transferred to task

