# -*- coding: utf-8 -*-

require 'rubygems'
require 'log4r'

include Log4r
include MailProcessor

class File
  def self.read_binary filename
    f = File.new(filename, "rb")
    content = f.read()
    f.close()
    content
  end
end

module MailProcessor

  class MailDir
    def initialize options = {}, &block
      @log = Logger.new self.class.to_s
      @log.outputters = Outputter.stdout

      @attributes = {
        :glob => "#{ENV['HOME']}/MailDir/new/*",
      }.merge(options)
      instance_eval &block if block_given?
    end


    def glob v = nil
      if v
        @attributes[:glob] = v
      else
        @attributes[:glob]
      end
    end


    def process(options = {}, &block)
      a = @attributes.merge(options)

      count = 0
      Dir.glob(a[ :glob ]) do |filename|
        yield(File.read_binary(filename))
        FileUtils::rm(filename)
        count += 1
      end
      @log.info "Processed #{count} mails"

      count == 0
    end

  end
end
