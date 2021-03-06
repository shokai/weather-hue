#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler'
Bundler.require

args = ArgsParser.parse ARGV do
  arg :city, 'city', :alias => :c, :default => '東京'
  arg :rain, '降水確率のしきい値 (%)', :default => 30
  arg :help, 'show help', :alias => :h
  arg :hue, 'hue light number', :default => 0

  on :help do
    STDERR.puts help
    STDERR.puts "e.g.  ruby #{$0} -city 鎌倉"
    exit 1
  end
end

weather = WeatherJp.get args[:city], :today
puts "#{weather} - #{Time.now}"

light = Hue::Client.new.lights[ args[:hue].to_i ]
puts "light : #{light.name}"
light.on = true
light.saturation = 180
light.brightness = 200

if weather.rain < args[:rain]
  light.hue = 60000 # red
else
  light.hue = 47000 # blue
end
