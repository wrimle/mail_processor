# -*- coding: utf-8 -*-

include MailProcessor

module MailProcessor
  class Processor < Base
    def initialize options = {}, &block
      @attributes = {
        :retriever => nil
      }
      instance_eval &block
      self
    end


    def retriever method, options = {}, &block
      @retriever = case method
                   when :pop3 then
                     Pop3.new options, &block
                   when :mail_dir then
                     MailDir.new options, &block
                   else
                     raise UnkownRetrieverError, "Retriever type #{method.to_s} not known"
                   end
    end


    def process options = {}, &block
      @retriever.process &block
    end

  end

end
