# frozen_string_literal: true

require 'yard'
require 'runeterra_cards/version'

# Convert `{version}` in markup files to the latest version of the library, i.e. {RuneterraCards::VERSION}
module VersionHelper
  def resolve_links(text)
    text = text.gsub(/{version}/, RuneterraCards::VERSION)
    super(text)
  end
end

YARD::Templates::Template.extra_includes << VersionHelper
