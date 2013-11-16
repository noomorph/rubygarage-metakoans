module ::Kernel
  @@default_values = {}

  def initialize
    @@default_values.each_pair do |attr_name, value|
      variable = :"@#{attr_name}"
      instance_variable_set variable, value
    end
  end

  def attribute(config, &block)
    if config.is_a? Hash
      attr_name = config.keys.first
      @@default_values[attr_name] = config.values.first
    elsif config.is_a? String
      attr_name = config
    end

    variable = :"@#{attr_name}"
    getter = attr_name.to_sym
    setter = "#{attr_name}=".to_sym
    checker = "#{attr_name}?".to_sym
    uses_block = block_given?

    define_method getter do
      if uses_block
        self.instance_eval(&block)
      else
        instance_variable_get variable
      end
    end

    define_method setter do |value|
      instance_variable_set variable, value
      uses_block = false
    end

    define_method checker do
      return true if uses_block
      instance_variable_defined? variable and
      instance_variable_get variable
    end
  end
end
