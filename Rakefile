# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

require 'motion-testflight'

is_test = ARGV.join(' ') =~ /spec/
if is_test
  require 'guard/motion'
  Bundler.require :default, :spec
else
  Bundler.require
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'PixivReader'
  app.prerendered_icon = false
  app.icons = ["Icon-40.png", "Icon-40@2x.png",
               "Icon-60.png", "Icon-60@2x.png",
               "Icon-76.png", "Icon-76@2x.png",
               "Icon-Small.png", "Icon-Small@2x.png"]
  if is_test
    app.redgreen_style = :full
  end
end
