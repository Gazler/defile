require 'spec_helper'
require 'defile/cli'

describe Defile::CLI do

  let(:test_folder) { "/tmp/.defile" }
  let(:home_folder) { "/tmp/pretend_home" }
  
  before(:each) do
    @cli = Defile::CLI.new
    #Let's do some cleanp

    FileUtils.rm_rf(test_folder)
    FileUtils.cp_r("spec/support/", test_folder)

    FileUtils.rm_rf(home_folder)
    FileUtils.mkdir(home_folder)

    #We don't want our tests to do anything with our files

    @cli.class.send(:remove_const, "HOME_DIR")
    @cli.class.const_set("HOME_DIR", home_folder)
    @cli.class.send(:remove_const, "DEFAULT_DIR")
    @cli.class.const_set("DEFAULT_DIR", test_folder)
  end

  context ".user" do
    it "should display the help if the name is not set" do
      @cli.should_receive(:help) 
      @cli.user
    end
  end

  context ".package" do
    it "should create a git commit with the files" do
      @cli.package
      Dir.chdir("#{test_folder}/backup")
      `git log --pretty=oneline`.should include("Defile package")
      Dir.glob("{*,.*}").should eql(%W{.git . .bashrc ..})
    end
  end

  context ".link" do
    it "should link all the files" do
      @cli.link 
      Dir.chdir(home_folder)
      %w{.bashrc}.each do |file|
        File.symlink?(file).should be_true
        File.readlink(file).should eql("#{test_folder}/#{file}")
      end
    end
  end

  context ".make_and_move_dir" do
    it "should create the directory if it doesn't exist" do
      File.stub(:exists?).with("/foo").and_return(false) 
      Dir.should_receive(:mkdir).with("/foo")
      Dir.should_receive(:chdir).with("/foo")
      @cli.make_and_move_dir("/foo")
    end

    it "should move if the directory if it does exist" do
      File.stub(:exists?).with("/foo").and_return(true) 
      Dir.should_not_receive(:mkdir).with("/foo")
      Dir.should_receive(:chdir).with("/foo")
      @cli.make_and_move_dir("/foo")
    end
  end
end
