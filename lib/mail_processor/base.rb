# -*- coding: utf-8 -*-

require 'rubygems'
require 'log4r'

module MailProcessor
  class UnkownRetrieverError < StandardError; end

  log = Log4r::Logger.new "MailProcessor"
  log.outputters = Log4r::Outputter.stdout

  class Base
    begin
      @log = Log4r::Logger.new "MailProcessor::#{self.to_s}"
    end

    def self.log
      @log
    end

    def log
      self.class.log
    end
  end



  # Symbolizes keys from yaml hashes while merging
  def merge_to_attributes other
    h = @attributes
    other.each do |k, v|
      h[k.to_sym] = v
    end
    self
  end

end


class File
  def self.read_binary filename
    f = File.new(filename, "rb")
    content = f.read()
    f.close()
    content
  end
end

