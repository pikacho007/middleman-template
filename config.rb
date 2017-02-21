###
# Page options, layouts, aliases and proxies
###

set :css_dir, 'style'
set :js_dir, 'script'
set :images_dir, 'img'
# set :build_dir, '../html'

set :slim, { pretty: true, sort_attrs: false, format: :html5 }

# 他言語化
# activate :i18n

# URL access xxx.hmtl -> /xxx/
activate :directory_indexes

activate :automatic_image_sizes

activate :external_pipeline,
   name: :webpack,
   command: build? ?
   "./node_modules/webpack/bin/webpack.js --bail -p" :
   "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
   source: ".tmp/dist",
   latency: 1

# デプロイ設定
activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.build_before = true
  deploy.branch = 'master'
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

  def current_page?(path)
    current_page.url == path
  end

  # 高解像度画像の指定
  def img_tag(src, options = {})
    # alt属性などをoptionsで指定できるようにしている
    retina_src = src.gsub(%r{\.\w+$}, '@2x\0')
    image_tag(src, options.merge(srcset: "#{retina_src} 2x"))
  end

  # 高解像度画像の指定
  def img_tag_sp(src, options = {})
    sp_src = src.gsub(%r{\.\w+$}, '-sp\0')

    # classキー付与。既存の値がある場合は連結。
    pc_opt = options.merge(class: 'pc'){ |key, v0, v1| "#{v0} #{v1}" }
    sp_opt = options.merge(class: 'sp'){ |key, v0, v1| "#{v0} #{v1}" }

    # idキーが付いていた場合は'_sp'を付ける
    if(sp_opt[:id])
      sp_opt[:id] = sp_opt[:id]+'_sp'
    end

    img_tag(src, pc_opt) + img_tag(sp_src, sp_opt)
  end

  def nl2br(txt)
    txt.gsub(/(\r\n|\r|\n)/, "<br>")
  end

  # 現在のページの別言語のページヘのパスを取得する
  # http://forum.middlemanapp.com/t/i18n-list-of-language-siblings-and-links-to-them/978/2
  def translated_url(locale)
    # Assuming /:locale/page.html

    untranslated_path = @page_id.split("/", 2).last.sub(/\..*$/, '')

    if untranslated_path==="index"
      untranslated_path = ""
      path = (locale===:en) ? "/" : "/ja/"
    else
      begin
        translated = I18n.translate!("paths.#{untranslated_path}", locale: locale)
      rescue I18n::MissingTranslationData
        translated = untranslated_path
      end
      path = (locale===:en) ? "/#{translated}/" : "/#{locale}/#{translated}/"
    end

    asset_url(path)
  end

  def other_langs
    langs - [I18n.locale]
  end

end


