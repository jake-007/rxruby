# Copyright (c) Microsoft Open Technologies, Inc. All rights reserved. See License.txt in the project root for license information.

require 'rx/core/observer'
require 'rx/core/notification'
require 'rx/testing/recorded'

module Rx

  class MockObserver < ObserverBase
    attr_reader :messages

    def initialize(scheduler)
      raise 'scheduler cannot be nil' unless scheduler

      @scheduler = scheduler
      @messages = []
    end

    def on_next(value)
      messages.push(Recorded.new(@scheduler.now, Notification.create_on_next(value)))
    end

    def on_error(error)
      messages.push(Recorded.new(@scheduler.now, Notification.create_on_error(error)))
    end

    def on_completed
      messages.push(Recorded.new(@scheduler.now, Notification.create_on_completed))
    end
  end
end
