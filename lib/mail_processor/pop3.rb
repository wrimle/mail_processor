# -*- coding: utf-8 -*-

require 'net/pop'

include MailProcessor

module MailProcessor

  class Pop3 < Base
    def initialize options = {}, &block
      @attributes = {
        :address => "pop.gmail.com",
        :port => 110, # 995,
        :username => nil,
        :password => nil,
        # Must have ruby 1.9 to use this
        :use_ssl => false, # true 
      }
      merge_to_attributes(options)

      instance_eval &block if block_given?
      self
    end


    def address v = nil
      if v
        @attributes[:address] = v
      else
        @attributes[:address]
      end
    end


    def port v = nil
      if v
        @attributes[:port] = v
      else
        @attributes[:port]
      end
    end


    def username v = nil
      if v
        @attributes[:username] = v
      else
        @attributes[:username]
      end
    end


    def password v = nil
      if v
        @attributes[:password] = v
      else
        @attributes[:password]
      end
    end


    def use_ssl?
      @attributes[:use_ssl]
    end


    def use_ssl v = nil
      if v
        @attributes[:use_ssl] = v
      else
        @attributes[:use_ssl]
      end
    end


    def process(options = {}, &block)
      a = @attributes.merge(options)

      didWork = false
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if a[:use_ssl]
      pop = Net::POP3.new(a[:address], a[:port])
      pop.start(a[:username], a[:password])
      if pop.mails.empty?
        log.info 'No mail.'
      else
        pop.each_mail do |m|
          yield m.pop
          m.delete
        end
        log.info "Processed #{pop.mails.size} mails."
        pop.finish
        didWork = true
      end

      didWork
    end
  end
end
