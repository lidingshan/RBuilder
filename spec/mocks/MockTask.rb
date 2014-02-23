CURRENT_DIR = File.expand_path File.dirname(__FILE__)

require CURRENT_DIR + '/../../task'

class MockTask < Task
    attr_reader :param1, :param2, :name

    def initialize(config, remote)
        @param1 = config['param1']
        @param2 = config['param2']
        @name = config['name']
    end
end