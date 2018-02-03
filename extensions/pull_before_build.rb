# frozen_string_literal: true
# To avoid losting old deploy history by force push
class PullBeforeBuild < ::Middleman::Extension
  def before_build(_builder)
    p ':::before_build:::'
    if Dir.exist?('build')
      Dir.chdir 'build'
      system 'git branch -u origin/master master'
      system 'git pull origin'
      Dir.chdir '..'
    else
      p 'There isn\'t build dir yet, so do nothing.'
    end
  end
end

::Middleman::Extensions.register(:pull_before_build, PullBeforeBuild)
