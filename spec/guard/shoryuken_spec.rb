require 'spec_helper'
require 'guard/compat/test/helper'

describe Guard::Shoryuken, exclude_stubs: [Guard::Plugin] do
  describe 'start' do

    it 'should accept :concurrency option' do
      concurrency = 10

      obj = Guard::Shoryuken.new :concurrency => concurrency
      obj.send(:cmd).should include "--concurrency #{concurrency}"
    end

    describe 'with :queue option' do
      it 'accepts one queue' do
        queue = :foo

        obj = Guard::Shoryuken.new :queue => queue
        obj.send(:cmd).should include "--queue #{queue}"
      end

      it 'accepts array of :queue options' do
        queue = ['foo,4', 'default']

        obj = Guard::Shoryuken.new :queue => queue
        obj.send(:cmd).should include "--queue #{queue.first} --queue #{queue.last}"
      end
    end

    it 'should accept :require option' do
      obj = Guard::Shoryuken.new :require => './shoryuken_helper.rb'
      obj.send(:cmd).should include '--require ./shoryuken_helper.rb'
    end

    it 'should accept :config option' do
      config = 'config/my_config.yml'

      obj = Guard::Shoryuken.new :config => config
      obj.send(:cmd).should include "-C #{config}"
    end

    it 'should accept :rails option' do
      obj = Guard::Shoryuken.new :rails => true
      obj.send(:cmd).should include '--rails'
    end

    it 'accepts :logfile option' do
      logfile = 'log/my_logfile.log'
      obj = Guard::Shoryuken.new :logfile => logfile
      obj.send(:cmd).should include "--logfile #{logfile}"
    end

    it 'accepts :pidfile option' do
      logfile = 'my_pidfile.pid'
      obj = Guard::Shoryuken.new :logfile => logfile
      obj.send(:cmd).should include "--logfile #{logfile}"
    end

    it 'should accept :verbose option' do
      obj = Guard::Shoryuken.new :verbose => true
      obj.send(:cmd).should include '--verbose'
    end

    it 'should provide default options' do
      obj = Guard::Shoryuken.new
      obj.send(:cmd).should include "--concurrency #{Guard::Shoryuken::DEFAULT_CONCURRENCY}"
      obj.send(:cmd).should include '--verbose'
      obj.send(:cmd).should_not include '--queue'
      obj.send(:cmd).should_not include '--require'
      obj.send(:cmd).should_not include '-C'
      obj.send(:cmd).should_not include '--rails'
      obj.send(:cmd).should_not include '--logfile'
      obj.send(:cmd).should_not include '--pidfile'
    end

  end
end
