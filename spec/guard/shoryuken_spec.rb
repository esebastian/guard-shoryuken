require 'spec_helper'

describe Guard::Shoryuken do
  describe 'start' do

    it 'accepts :environment option' do
      environment = :foo

      obj = Guard::Shoryuken.new :environment => environment
      obj.send(:cmd).should include "--environment #{environment}"
    end

    it 'accepts :logfile option' do
      logfile = 'log/shoryuken.log'
      obj = Guard::Shoryuken.new :logfile => logfile
      obj.send(:cmd).should include "--logfile #{logfile}"
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

    it 'should accept :timeout option' do
      timeout = 2

      obj = Guard::Shoryuken.new :timeout => timeout
      obj.send(:cmd).should include "--timeout #{timeout}"
    end

    it 'should accept :concurrency option' do
      concurrency = 2

      obj = Guard::Shoryuken.new :concurrency => concurrency
      obj.send(:cmd).should include "--concurrency #{concurrency}"
    end

    it 'should accept :config option' do
      config = 'shoryuken.yml'

      obj = Guard::Shoryuken.new :config => config
      obj.send(:cmd).should include "-C #{config}"
    end


    it 'should accept :verbose option' do
      obj = Guard::Shoryuken.new :verbose => true
      obj.send(:cmd).should include '--verbose'
    end

    it 'should accept :require option' do
      obj = Guard::Shoryuken.new :require => './shoryuken_helper.rb'
      obj.send(:cmd).should include '--require ./shoryuken_helper.rb'
    end

    it 'should provide default options' do
      obj = Guard::Shoryuken.new
      obj.send(:cmd).should include "--concurrency #{Guard::Shoryuken::DEFAULT_CONCURRENCY}"
      obj.send(:cmd).should include '--verbose'
    end

  end
end
