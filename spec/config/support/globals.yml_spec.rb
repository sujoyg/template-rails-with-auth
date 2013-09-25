require 'spec_helper'
require 'globals'

describe 'config/support/globals.yml' do
  let(:user) { random_text }
  let(:globals) do
    with_user(user) do
      configs = [:development, :production, :sandbox, :test].map do |e|
        [e, Globals.read('config/support/globals.yml', e)]
      end
      Hash[*configs.flatten]
    end
  end

  [:development, :production, :sandbox, :test].each do |environment|
    it "should not raise any error for #{environment}." do
      expect { Globals.read('config/support/globals.yml', environment) }.to_not raise_error
    end
  end

  it 'should raise an error for unknown environments.' do
    expect {
      Globals.read('config/support/globals.yml', 'foo')
    }.to raise_error('Globals were not defined for environment: foo in config/support/globals.yml')
  end

  describe 'application' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        globals[environment].application.should == '$name;format="Camel"$'
      end
    end
  end

  describe 'deployment' do
    describe 'dir' do
      [:sandbox, :production].each do |environment|
        it environment do
          globals[environment].deployment.dir.should == '/mnt/deployment/$name;format="camel,lower"$'
        end
      end
    end

    describe 'host' do
      it 'sandbox' do
        globals[:sandbox].deployment.host.should == "#{user}.i.$name;format="camel,lower"$.cc"
      end

      it 'production' do
        globals[:production].deployment.host.should == '$name;format="camel,lower"$.cc'
      end
    end

    describe 'repository' do
      [:development, :production, :sandbox, :test].each do |environment|
        it environment do
          globals[environment].deployment.repository.should == "git@github.com:sujoyg/$name;format="camel,lower"$.git"
        end
      end
    end

    describe 'user' do
      [:production, :sandbox].each do |environment|
        it environment do
          globals[environment].deployment.user.should == 'user'
        end
      end
    end
  end

  describe 'host' do
    it 'development' do
      globals[:development].host.should == 'localhost:3000'
    end

    it 'production' do
      globals[:production].host.should == '$name;format="camel,lower"$.cc'
    end

    it 'sandbox' do
      globals[:sandbox].host.should == "#{user}.i.$name;format="camel,lower"$.cc"
    end

    it 'test' do
      globals[:test].host.should == 'test.host'
    end
  end

  describe 'token' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        globals[environment].token.should == "7dfab5bbd04aed2e245b57163e29548b2530273d43707661b029ec959473310ae31b76dd64723c9a470e38531149d1b10987786af8731a63c77f6312c781c08"
      end
    end
  end
end