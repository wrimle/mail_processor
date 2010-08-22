# -*- coding: utf-8 -*-


include MailProcessor

module MailProcessor

  class MailDir < Base
    def initialize options = {}, &block
      @attributes = {
        :glob => "#{ENV['HOME']}/MailDir/new/*",
      }
      merge_to_attributes(options)
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
      log.info "Processed #{count} mails"

      count == 0
    end

  end
end
