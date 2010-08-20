require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'yaml'

describe "MailProcessor" do

  context "Pop3" do
    it "works" do
      unless(File.exists?("spec/pop3.yaml"))
        pending("needs a real mail account")
      end

      config = YAML.load_file("spec/pop3.yaml")
      processor = Processor.new do
        retriever :pop3, config["pop3"]
      end

      processor.process do |popped|
        puts popped
      end
    end
  end


  context "MailDir" do
    it "works" do
      FileUtils::mkdir_p("spec/MailDir/new")
      Dir.glob("spec/data/*.eml") do |filename|
        FileUtils::cp(filename, "spec/MailDir/new/")
      end
      processor = Processor.new do
        retriever :mail_dir do
          glob "./spec/MailDir/new/mail*.eml"
        end
      end

      processor.process do |popped|
        puts popped
      end
    end
  end

end
