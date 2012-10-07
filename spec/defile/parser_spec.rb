require 'spec_helper'
require 'defile/parser'

describe Defile::Parser do

  context "#comment_char" do
    it "should return -- for haskell" do
      Defile::Parser.comment_char("hs").should eql("--") 
    end

    it "should return # for anything else" do
      Defile::Parser.comment_char("rb").should eql("#") 
      Defile::Parser.comment_char("bashrc").should eql("#") 
      Defile::Parser.comment_char("xsession").should eql("#") 
    end

  end

  context "#parse" do

    it "should call parse_file on non-ignored files" do
      Dir.stub(:glob).with("{*,.*}").and_return(%w{. .. .bashrc .git})
      Defile::Parser.should_receive(:parse_file).with(".bashrc")

      Defile::Parser.should_not_receive(:parse_file).with(".")
      Defile::Parser.should_not_receive(:parse_file).with("..")
      Defile::Parser.should_not_receive(:parse_file).with(".git")
      Defile::Parser.parse
    end

  end

end
