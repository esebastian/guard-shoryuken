require 'spec_helper'
require 'guard/compat/test/helper'

describe Guard::Shoryuken, exclude_stubs: [Guard::Plugin] do
  describe 'start' do

    it 'accepts :concurrency option' do
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

    it 'accepts :require option' do
      obj = Guard::Shoryuken.new :require => './shoryuken_helper.rb'
      obj.send(:cmd).should include '--require ./shoryuken_helper.rb'
    end

    it 'accepts :config option' do
      config = 'config/my_config.yml'

      obj = Guard::Shoryuken.new :config => config
      obj.send(:cmd).should include "-C #{config}"
    end

    it 'accepts :rails option, which implies :config option with default value' do
      default_config = 'config/shoryuken.yml'

      obj = Guard::Shoryuken.new :rails => true
      obj.send(:cmd).should include "-R -C #{default_config}"
    end

    it 'accepts :rails option and explicit :config option with custom value' do
      config = 'config/my_config.yml'

      obj = Guard::Shoryuken.new :rails => true, :config => config
      obj.send(:cmd).should include "-R -C #{config}"
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

    it 'accepts :verbose option' do
      obj = Guard::Shoryuken.new :verbose => true
      obj.send(:cmd).should include '--verbose'
    end

    it 'provides default options' do
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
