# frozen_string_literal: true
require 'extensions/pull_before_build'

PRODUCTION_URL = 'https://example.com'
STAGING_URL = 'https://stg.example.com'

DeployBranch = 'staging'

###
# Page options, layouts, aliases and proxies
###

set :css_dir, 'style'
set :js_dir, 'script'
set :images_dir, 'img'
# set :build_dir, '../html'

set :slim, pretty: true, sort_attrs: false, format: :html

# Multiple languages
# activate :i18n

activate :asset_hash

# URL access xxx.hmtl -> /xxx/
activate :directory_indexes

activate :automatic_image_sizes

activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 11']
end

activate :external_pipeline,
         name: :webpack,
         command: if build?
                    './node_modules/webpack/bin/webpack.js --bail -p'
                  else
                    './node_modules/webpack/bin/webpack.js --watch -d --progress --color'
                  end,
         source: '.tmp/dist',
         latency: 1

activate :pull_before_build

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.build_before = true
  deploy.branch = DeployBranch
end

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end

###
# Helpers
###

helpers do
  def site_url
    if config[:environment] == :development
      'http://localhost:4567'
    elsif DeployBranch == 'staging'
      STAGING_URL
    else
      PRODUCTION_URL
    end
  end

  def current_page?(path)
    current_page.url == path
  end

  # support high res images
  # Usage: =img_tag '/img/example.png', alt: 'description'
  def img_tag(src, options = {})
    # enable to set attributes in options
    retina_src = src.gsub(/\.\w+$/, '@2x\0')
    image_tag(src, options.merge(srcset: "#{retina_src} 2x"))
  end

  # Usage: =img_tag_sp '/img/example.png', alt: 'description'
  def img_tag_sp(src, options = {})
    sp_src = src.gsub(/\.\w+$/, '-sp\0')

    # class treatment
    pc_opt = options.merge(class: 'pc') { |_key, v0, v1| "#{v0} #{v1}" }
    sp_opt = options.merge(class: 'sp') { |_key, v0, v1| "#{v0} #{v1}" }

    # id treatment
    sp_opt[:id] = sp_opt[:id] + '_sp' if sp_opt[:id]

    img_tag(src, pc_opt) + img_tag(sp_src, sp_opt)
  end
  
  # image_tag with sp image
  def image_tag_sp(src, options = {})
    sp_src = src.gsub(/\.\w+$/, '-sp\0')

    # class treatment
    pc_opt = options.merge(class: 'pc') { |_key, v0, v1| "#{v0} #{v1}" }
    sp_opt = options.merge(class: 'sp') { |_key, v0, v1| "#{v0} #{v1}" }

    # id treatment
    sp_opt[:id] = sp_opt[:id] + '_sp' if sp_opt[:id]

    image_tag(src, pc_opt) + image_tag(sp_src, sp_opt)
  end

  def nl2br(txt)
    txt.gsub(/(\r\n|\r|\n)/, '<br>')
  end

  # Get another language page url
  # http://forum.middlemanapp.com/t/i18n-list-of-language-siblings-and-links-to-them/978/2
  def translated_url(locale)
    # Assuming /:locale/page.html

    untranslated_path = @page_id.split('/', 2).last.sub(/\..*$/, '')

    if untranslated_path == 'index'
      untranslated_path = ''
      path = locale == :en ? '/' : '/ja/'
    else
      begin
        translated = I18n.translate!("paths.#{untranslated_path}", locale: locale)
      rescue I18n::MissingTranslationData
        translated = untranslated_path
      end
      path = locale == :en ? "/#{translated}/" : "/#{locale}/#{translated}/"
    end

    asset_url(path)
  end

  def other_langs
    langs - [I18n.locale]
  end

  # Include svg file in line
  # https://gist.github.com/bitmanic/0047ef8d7eaec0bf31bb
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
