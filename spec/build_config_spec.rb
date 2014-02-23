require 'rspec'
require './build_config'
describe BuildConfig do

    before(:each) do
        @config = BuildConfig.new('spec/test_build.yml')
    end

    it 'should be able to load build configure file' do
        expect(@config).to be_true
    end

    it 'should be able to get one task configuration by task key' do
        task1_config = @config.get_task_config('task1')
        expect(task1_config['classname']).to eq('TestTask1')
    end

    it 'should be able to get task name' do
        task1_config = @config.get_task_config('task1')
        expect(task1_config['name']).to eq('Task1')
    end
end