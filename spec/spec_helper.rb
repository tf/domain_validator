$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'domain_validator'
require 'rspec'
require 'active_model'

class Model
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :domain, :string
end

RSpec.configure do |c|
  require 'support/domain_helpers'
  require 'support/translations_helpers'
  c.extend DomainHelpers
  c.include TranslationsHelpers
end
