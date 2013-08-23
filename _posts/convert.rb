#!/usr/bin/env ruby
require 'date'

HEADER = <<-TXT
---
layout: default
title: %s
category: unicode
---
TXT

P = "<p>%s</p>"
FONT = "<span class='mm3'>%s</span>"
MY = "<p class='my'>%s</p>"
HIDE = "<p class='hide-this'>%s</p>"

def fmt(txt, format=P)
  sprintf(format, txt)
end

def deduct_random_days(date)
  date - Random.rand(1..20) 
end

all = IO.read("all.txt").split(/^=+$\n+/)

dt = Date.new(2013, 06, 10)
all.each do |post|
  hide = false
  pars = post.split(/\n+/)
  title = pars.shift

  formatted_post = "#{fmt(title, HEADER)}\n"
  formatted_post += pars.map do |par|
    par_with_p = if par =~ /^[\u1000-\u109F ]+$/
      hide = true
      fmt(par, MY)
    elsif hide
      hide = false
      fmt(par, HIDE)
    else
      fmt(par)
    end
    par_with_p.gsub(/(?:\s*[\u1000-\u109F]+\s*[\u1000-\u109F]+\s*)+/) { |b| fmt(b, FONT) }
  end.join("\n")

  File.open("new/#{dt.strftime("%Y-%m-%d")}-#{title.gsub(/\s/, "-").downcase}.md", "w") do |f|
    f.puts formatted_post
  end

  dt = deduct_random_days(dt)
  #exit
end
