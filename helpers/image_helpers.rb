# Middleman - Inline SVG Helper
# ------------------------------------------------------------------------------
#
# Installation
# ------------
# 1. Save this file at `[project_root]/helpers/image_helpers.rb`
# 2. Open the project's Gemfile and add this line: `gem "oga"`
# 3. Run `bundle install` from the command line
#
# Note: Restart your local Middleman server (if it's running) before continuing
#
# Usage
# -----
# Embed SVG files into your template files like so:
#
# ```
# <%= inline_svg "name/of/file.svg" %>
# ```
#
# The helper also allows you to pass attributes to add to the SVG tag, like so:
#
# Input:
# ```
# <%= inline_svg "name/of/file.svg", class: "foo", data: {bar: "baz"} %>
# ```
#
# Output:
# ```
# <svg <!-- existing attributes --> class="foo" data-bar="baz">
#   <!-- SVG contents -->
# </svg>
# ```
#
# Acknowledgements and Contributors
# --------------------------
# This was initally adapted from the work of James Martin
# and Steven Harley, which you can read more about here:
# https://robots.thoughtbot.com/organized-workflow-for-svg
#
# Further improvements were made based on contributions by:
#
# * Cecile Veneziani (@cveneziani)
# * Allan White (@allanwhite)
#
# Thanks for improving this helper! Have questions or concerns?
# Feel free to fork the Gist or comment on it here:
# https://gist.github.com/bitmanic/0047ef8d7eaec0bf31bb
module ImageHelpers
  def inline_svg(relative_image_path, optional_attributes = {})
    image_path = File.join(config[:source], config[:images_dir], relative_image_path)

    # If the image was found...
    if File.exists?(image_path)
      # Open the image
      image = File.open(image_path, 'r') { |f| f.read }

      # Return the image if no optional attributes were passed in
      return image if optional_attributes.empty?

      # Otherwise, parse the image
      document = Oga.parse_xml(image)
      svg      = document.css('svg').first

      # Then, add the attributes
      # NOTE: This allows for hash-based values, but we're only going one level
      #       deep right now. If you know a great way to dig `N` levels deeper,
      #       feel free to post about it on the Gist.
      optional_attributes.each do |attribute, value|
        case value

        when Hash
          value.each do |subattribute, subvalue|
            unless subvalue.class == Hash
              svg.set(
                "#{attribute} #{subattribute}".parameterize,
                subvalue.html_safe
              )
            end
          end

        else
          svg.set(attribute.to_sym, value.html_safe)

        end
      end

      # Finally, return the image
      document.to_xml

    # If the file wasn't found...
    else
      # Embed an inline SVG image with an error message
      %(
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 30"
          width="400px" height="30px"
        >
          <text font-size="16" x="8" y="20" fill="#cc0000">
            Error: '#{relative_image_path}' could not be found.
          </text>
          <rect
            x="1" y="1" width="398" height="28" fill="none"
            stroke-width="1" stroke="#cc0000"
          />
        </svg>
      )
    end
  end
end