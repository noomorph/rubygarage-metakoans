require 'pry'

class ::Module

  def attribute(config, &block)
    if config.is_a? Hash
      attr_name = config.keys.first
      attr_default_value = config.values.first
    else
      attr_name = config.to_s
      attr_default_value = block if block_given?
    end

    instance_var = :"@#{attr_name}"
    getter = :"#{attr_name}"
    setter = :"#{attr_name}="
    checker = :"#{attr_name}?"

    define_method getter do
      if instance_variable_defined?(instance_var)
        instance_variable_get instance_var
      else
        if (attr_default_value.is_a? Proc)
          instance_eval(&attr_default_value)
        elsif attr_default_value
          attr_default_value
        end
      end
    end

    define_method setter do |value|
      instance_variable_set instance_var, value
    end

    define_method checker do
      !!send(getter) 
    end
  end
end