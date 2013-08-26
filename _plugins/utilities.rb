module Utilities
  def self.dasherize(str)
    str.gsub(/[^a-zA-Z0-9]+/, "-")
  end
end
