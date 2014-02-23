require 'rspec'
require 'rspec/mocks'
require 'fileutils'

require './task'
require './task/XCopyTask'

describe XCopyTask do 

    before(:each) do
        mock_config = double('BuildConfig')

        @xcopy_task_config = {
            'source' => 'spec/testfolder',
            'destination' => 'spec/testdestination'
        }

        @remote_config = {
            'hostname' => 'mockhost',
            'source_copy_to' => 'spec/testdestination'
        }

        @remote = double("RemoteServer")
        @remote.stub(:source_copy_to => 'spec/testdestination')
        @remote.stub(:hostname => 'mockhost')
        @remote.stub(:config => @remote_config)
        @remote.stub(:read_attribute).with('source_copy_to').and_return('spec/testdestination')
        
        @xcopy_task = XCopyTask.new(@xcopy_task_config, @remote)
    end

    after(:each) do
        FileUtils.rm_rf(Dir.glob(@xcopy_task.destination + '/*'))         
    end
    
    it 'should be a type of Task' do
        expect(@xcopy_task.is_a?(Task)).to be_true
    end

    it 'should have task name of xcopy' do
        expect(@xcopy_task.name).to eq('xcopy')
    end

    it 'should get destination path of xcopy from config' do
        expect(@xcopy_task.destination).to eq(@remote_config['source_copy_to'])
    end

    it 'should be able to be executed to copy files from soruce to destination' do
        expect(@xcopy_task.run).to be_true
        
        files = Dir[@xcopy_task.destination + '/*']
        expect(files.length).to be > 0
    end
end