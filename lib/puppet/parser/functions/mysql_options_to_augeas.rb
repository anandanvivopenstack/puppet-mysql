module Puppet::Parser::Functions
  newfunction(:mysql_options_to_augeas, :type => :rvalue) do |args|
    h = {}
    args[0].map do |section, options|
      options.map do |k, v|
        h["#{section}/#{k}"] = {
          :changes => [
            "set target[.='#{section}'] #{section}",
            "set target[.='#{section}']/#{k} #{v}",
            'rm target[count(*)=0]',
          ],
        }
      end
    end
    h
  end
end
