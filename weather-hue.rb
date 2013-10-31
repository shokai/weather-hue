#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$stdout.sync = true
require 'rubygems'
require 'bundler'
Bundler.require

args = ArgsParser.parse ARGV do
  arg :city, 'city', :alias => :c, :default => '東京'
  arg :rain, '降水確率のしきい値 (%)', :default => 30
  arg :help, 'show help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  STDERR.puts "e.g.  ruby #{$0} -city 鎌倉"
  exit 1
end

begin
  weather = WeatherJp.get args[:city], :today
rescue StandardError, Timeout::Error => e
  STDERR.puts e
  exit 1
end
puts "#{weather} - #{Time.now}"

hue = Hue::Client.new
light = hue.lights[0]
puts "light : #{light.name}"

if weather.rain > args[:rain]
  light.hue = 7000
  light.saturation = 180
  light.brightness = 200
else
  light.hue = 0
  light.saturation = 180
  light.brightness = 200
end
