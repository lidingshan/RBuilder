require 'rspec'
require './argument_parser'

describe ArgumentParser do
    before(:each) do
        @args = []
        @args << '-t:task1'
        @args << '-r:dev035'
        @args << '-config:build.yml'
        @args << '-env:environment.yml'

        @parser = ArgumentParser.new(@args)
    end
    
    it 'should get task name when argument start with -t:' do
        expect(@parser.arg_values['t']).to eq('task1')
    end

    it 'should get remote server key when argument start with -r:' do
        expect(@parser.arg_values['r']).to eq('dev035')
    end

    it 'should get build config path when argument start with -config:' do
        expect(@parser.arg_values['config']).to eq('build.yml')
    end
    it 'should get environment config path when argument start with -env:' do
        expect(@parser.arg_values['env']).to eq('environment.yml')
    end
end