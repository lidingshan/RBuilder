require 'rspec'
require 'rspec/mocks'
require 'fileutils'
require './build_helper'

describe BuildHelper do

    before(:each) do
        @remote_config = {
            'source_copy_to' => 'spec/testdestination',
            'source_root' => 'LEE.BP\\SRC',
            'test_root' => 'LEE.BP\\TEST',
            'test_execution_home' => 'LEE.BP\\TEST'        
        }

        @remote = double("RemoteServer")
        @remote.stub(:source_copy_to => 'spec/testdestination')
        @remote.stub(:source_root => 'LEE.BP\\SRC')
        @remote.stub(:test_root => 'LEE.BP\\TEST')
        @remote.stub(:test_execution_home => 'LEE.BP\\TEST')
        @remote.stub(:config => @remote_config)

        @build_config = double("BuildConfig")
        @build_config.stub(:[]).with('tasks').and_return ['task1']        

        @mock_factory = double("TaskFactory")

        mock_task1_config = {'classname'=>'MockTask', 'path'=>'./spec/mocks', 'name'=>'mock1'}
        @build_config.stub(:get_task_config).with('task1').and_return(mock_task1_config)
        @mock_task1 = MockTask.new(mock_task1_config, @remote)
        @mock_factory.stub(:create_task).with(mock_task1_config, @remote).and_return(@mock_task1)

        mock_task2_config = {'classname'=>'MockTask', 'path'=>'./spec/mocks', 'name'=>'mock2'}
        @build_config.stub(:get_task_config).with('task2').and_return(mock_task2_config)
        @mock_task2 = MockTask.new(mock_task2_config, @remote)
        @mock_factory.stub(:create_task).with(mock_task2_config, @remote).and_return(@mock_task2)

        mock_task3_config = {'classname'=>'MockTask', 'path'=>'./spec/mocks', 'name'=>'mock3', 'depends_on'=>'task2'}
        @build_config.stub(:get_task_config).with('task3').and_return(mock_task3_config)
        @mock_task3 = MockTask.new(mock_task3_config, @remote)
        @mock_factory.stub(:create_task).with(mock_task3_config, @remote).and_return(@mock_task3)


        @helper = BuildHelper.new(@remote, @mock_factory, @build_config)
    end

    after(:each) do
        FileUtils.rm_rf(Dir.glob(@remote_config['source_copy_to'] + '/*')) 
    end

    it 'should be intialized successfully' do
        expect(@helper).to be_true
    end

    # it 'should be able to find out all source files from source code folder' do
    #     source_files = []
    #     root = @local.sourcecode_path + '/'
    #     @helper.get_files(root, nil, source_files)

    #     expect(source_files.include?('srcfile1.txt')).to be_true
    #     expect(source_files.include?('srcfile2.txt')).to be_true
    # end

    # it 'should be able to find out all source file recursively from source code folder' do
    #     source_files = []
    #     root = @local.sourcecode_path + '/'
    #     @helper.get_files(root, nil, source_files)

    #     expect(source_files.include?('subfolder/srcfile3.txt')).to be_true
    #     expect(source_files.include?('subfolder/srcfile4.txt')).to be_true
    #     expect(source_files.include?('subfolder/childfolder/srcfile5.txt')).to be_true
    # end

    # it 'should be able to xcopy one folder to specified remote destination' do
    #     expect(@helper.deploy_source_codes).to be_true
    #     files = Dir[@remote.source_copy_to + '/*']
    #     expect(files.length).to be > 0
    # end

    # it 'should be able to generate compile command for each source file' do
    #     expect_cmd = 'EB.COMPILE %s\\SUBFOLDER SOURCE1' % [@remote.source_root]
    #     actual_cmd = @helper.get_compile_command('SUBFOLDER/SOURCE1', @remote.source_root)
    #     expect(actual_cmd).to eq(expect_cmd)
    # end

    # it 'should be able to generate compile command for source file that under the root folder' do
    #     expected_cmd = 'EB.COMPILE %s SOURCE1' % [@remote.source_root]
    #     actual_cmd = @helper.get_compile_command('SOURCE1', @remote.source_root)
    #     expect(actual_cmd).to eq(expected_cmd)
    # end

    # it 'should be able to generate compile command for each test file' do
    #     expect_cmd = 'EB.COMPILE %s\\TEST TESTCASE' % [@remote.test_root]
    #     actual_cmd = @helper.get_compile_command('TEST/TESTCASE', @remote.test_root)
    #     expect(actual_cmd).to eq(expect_cmd)
    # end

    # it 'should be able to generate test execution command' do
    #     expect_cmd = 'JBUNIT.MAIN %s' % [@remote.test_execution_home]
    #     actual_cmd = @helper.get_test_exeuction_command
    #     expect(actual_cmd).to eq(expect_cmd)
    # end

    # it 'should get nil when try to compile a file which is in no compile files list' do
    #     actual_cmd = @helper.get_compile_command('src/no_compile.txt', @remote.source_root)
    #     expect(actual_cmd).to be_nil
    # end

    # it 'should be able to tell a successful compile' do
    #     compile_result = 'This is test compile result\n. Compile TESTCASE\nSource file TESTCASE compiled successfully'
    #     expect(@helper.check_compile_result(compile_result)).to be_true
    # end

    # it 'should be able to tell a failed compile' do
    #     compile_result = 'This is test compile result\n. Compile TESTCASE\nSource file TESTCASE compiled failed\nBut the file has been categorized successfully'
    #     expect(@helper.check_compile_result(compile_result)).to be_false
    # end

    it 'should be able to create task instances according to build configuration' do
        task_config = @build_config.get_task_config('task1')

        tasks = @helper.get_task(task_config)
        expect(tasks[0].is_a?(MockTask)).to be_true
    end

    it 'should be able to get task chain according to the dependency configuration' do
        task_config = @build_config.get_task_config('task3')
        tasks = @helper.get_task(task_config)
        
        expect(tasks.length).to eq(2)
        expect(tasks.pop.name).to eq('mock2')
        expect(tasks.pop.name).to eq('mock3')
    end
end


