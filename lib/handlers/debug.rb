require_relative 'base'

module Handlers
  class Debug < Base
    def handle
      return unless upper(:@@debug)
      @output = []

      build_output
    end

    def build_output
      puts "\n==== ActiveFormObjects Debugger #{@klass.class.name} ===="
      puts "\n👉   Called with\n #{@klass.class.name}.new(#{@raw_params}, #{@resource || 'nil'})"

      if upper(:@@resource).nil? && @resource.nil?
        puts "\n👉   No resource has been declared or given, calling save! will most likely fail."
      elsif !@resource.nil?
        puts "\n👉   The resource is a #{@resource.class.name}"
      end
      puts " @resource.update!(#{@params})\n\n"
    end
  end
end
