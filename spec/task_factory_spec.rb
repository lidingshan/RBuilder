require 'rspec'
require 'rspec/mocks'

require './spec/mocks/MockTask'
require './task_factory'
require './task'

describe TaskFactory do
    before(:each) do
        @factory = TaskFactory.new('./spec/mocks/')
    end

    it 'should create a task instance according to task name' do
        task_config = double('TaskConfig')
        task_config.stub(:[]).with('classname').and_return('MockTask')
        task_config.stub(:[]).with('path').and_return('./spec/mocks/')
        task_config.stub(:[]).with('param1').and_return('Task Parameter A')
        task_config.stub(:[]).with('param2').and_return('Task Parameter B')
        task_config.stub(:[]).with('name').and_return('Mock Task')

        task = @factory.create_task(task_config, nil)

        expect(task.is_a?(MockTask)).to be_true
        expect(task.is_a?(Task)).to be_true
        expect(task.param1).to eq('Task Parameter A')
        expect(task.param2).to eq('Task Parameter B')
    end

    it 'should set task load path to be default value if it has not been configured' do
        task_config = double('TaskConfig')
        task_config.stub(:[]).with('classname').and_return('MockTask')
        task_config.stub(:[]).with('path').and_return(nil)
        task_config.stub(:[]).with('param1').and_return('Task Parameter A')
        task_config.stub(:[]).with('param2').and_return('Task Parameter B')
        task_config.stub(:[]).with('name').and_return('Mock Task')

        task = @factory.create_task(task_config, nil)

        expect(task.is_a?(MockTask)).to be_true        
        expect(task.param1).to eq('Task Parameter A')
        expect(task.param2).to eq('Task Parameter B')        
    end
end