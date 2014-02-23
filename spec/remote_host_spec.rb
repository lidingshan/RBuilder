require 'rspec'
require 'yaml'
require './remote_server'

describe RemoteServer do
    before(:each) do
        @config = YAML.load_file('spec/test_config.yml')
        @server = RemoteServer.new(@config['dev035'])
        @is_login = @server.login
    end

    after(:each) do
        @server.close
    end

    it 'should be initialized successfully' do
        expect(@server).to be_true
    end

    it 'should get attributes of the server successfully' do
        expect(@server.hostname).to eq('INVSYDMDEV035')
        expect(@server.login_id).to eq('ap\\svc_t24dev035')
        expect(@server.password).to eq('HighRoad04')
        expect(@server.login_prompt).to eq('Account Name')
        expect(@server.password_prompt).to eq('Password:')
        expect(@server.terminal_prompt).to eq('jsh svc_t24dev035 ~ -->')
        expect(@server.source_copy_to).to eq('\\\\INVSYDMDEV035\\d$\\T24Build\\bnk.run\\LEE.BP\\JBUNIT\\')
        expect(@server.test_copy_to).to eq('\\\\INVSYDMDEV035\\d$\\T24Build\\bnk.run\\LEE.BP\\TEST\\')
        expect(@server.source_root).to eq('LEE.BP\\JBUNIT')
        expect(@server.test_root).to eq('LEE.BP\\TEST')
        expect(@server.test_execution_home).to eq('LEE.BP\\TEST')
        expect(@server.JBUNIT_HOME).to eq('d:\\T24Build\\bnk.run\\LEE.BP\\JBUNIT')    
    end

    it 'should be able to login remote server through telnet' do
        expect(@is_login).to be_true
    end

    it 'should be able execute command on remote server' do
        response = @server.execute('dir')
        expect(response.length).to be > 0
    end

    it 'should have login_id value to be same with username value if login_id was not configured' do
        server =  RemoteServer.new(@config['dev052'])
        expect(server.login_id).to eq('svc_t24dev035')
    end
end