# -*- ruby -*-

Dir['vendor/isolate*/lib'].each do |dir|
  $: << dir
end

require 'rubygems'
require 'isolate/now'
require 'hoe'

Hoe.spec 'osxscreenshot' do
  developer('Geoffrey Grosenbach', 'boss@topfunky.com')
  
  extra_deps << ['open4']
  
  # self.rubyforge_name = 'osxscreenshotx' # if different than 'osxscreenshot'
end

# vim: syntax=ruby
