class ArgumentParser
    attr_reader :arg_values

    def initialize(args)
        @arg_values = {}

        args.each { |arg|
            prefix = arg[/^-((.)+):/, 1]
            @arg_values[prefix] = get_argument_value(prefix, arg)
        }
    end

    private
    def get_argument_value(arg_prefix, arg)
        regex = "^-%s:((.)+)$" % [arg_prefix]
        value = arg[/#{regex}/, 1]
        value
    end
end