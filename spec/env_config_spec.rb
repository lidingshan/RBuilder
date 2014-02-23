require 'rspec'
require './environment_config'

describe 'Env YAML Config' do

    before(:each) do
        @env_config = EnvironmentConfig.new('spec/test_config.yml')
        @remote_config = @env_config.remote_config('dev035')
    end

    it 'should initialize successfully' do
        expect(@env_config).to be_true
    end

    it 'should load environment configuration successfully' do
        expect(@remote_config).to be_true
    end

    it 'should get remote_config config successfully' do
        expect(@remote_config['hostname']).to eq('INVSYDMDEV035')
        expect(@remote_config['username']).to eq('svc_t24dev035')
        expect(@remote_config['login_id']).to eq('ap\\{username}')
        expect(@remote_config['password']).to eq('HighRoad04')
        expect(@remote_config['login_prompt']).to eq('Account Name')
        expect(@remote_config['password_prompt']).to eq('Password:')
        expect(@remote_config['terminal_prompt']).to eq('jsh {username} ~ -->')
        expect(@remote_config['source_copy_to']).to eq('\\\\{hostname}\\d$\\T24Build\\bnk.run\\LEE.BP\\JBUNIT\\')
        expect(@remote_config['test_copy_to']).to eq('\\\\{hostname}\\d$\\T24Build\\bnk.run\\LEE.BP\\TEST\\')
        expect(@remote_config['source_root']).to eq('LEE.BP\\JBUNIT')
        expect(@remote_config['test_root']).to eq('LEE.BP\\TEST')
        expect(@remote_config['test_execution_home']).to eq('LEE.BP\\TEST')
        expect(@remote_config['JBUNIT_HOME']).to eq('d:\\T24Build\\bnk.run\\LEE.BP\\JBUNIT')
    end
end