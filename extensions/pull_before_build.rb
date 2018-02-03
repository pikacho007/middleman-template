# frozen_string_literal: true
# To avoid force push build directory and
class PullBeforeBuild < ::Middleman::Extension
  def before_build(_builder)
    p ':::before_build:::'
    if Dir.exist?('build')
      Dir.chdir 'build'
      p 'Execute "g pull origin"'
      system 'g pull origin'
      Dir.chdir '..'
    else
      p 'There isn\'t build dir yet, so do nothing.'
    end
  end
end

::Middleman::Extensions.register(:pull_before_build, PullBeforeBuild)
