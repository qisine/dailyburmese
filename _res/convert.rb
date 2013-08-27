#!/usr/bin/env ruby
require 'date'

HEADER = <<-TXT
---
layout: default
title: %s
category: unicode
keywords: 
---
TXT

P = "<p>%s</p>"
FONT = "<span class='mm3'>%s</span>"
TRIGGER = "<p class='hide-trigger'><a href='#'>+</a>%s</p>"
HIDE = "<p class='hide-this'>%s</p>\n"

def fmt(txt, format=P)
  sprintf(format, txt)
end

all = IO.read("all2.txt").split(/^=+$\n+/)

all.each do |post|
  hide = false
  pars = post.split(/\n+/)
  title = pars.shift
  dt = DateTime.parse(pars.shift) 

  formatted_post = "#{fmt(title, HEADER)}\n"
  formatted_post += pars.map do |par|
    par_with_p = if par =~ /^[\u1000-\u109F ]+$/
      hide = true
      fmt(par, TRIGGER)
    elsif hide
      hide = false
      fmt(par, HIDE)
    else
      fmt(par)
    end
    par_with_p.gsub(/(?<=^|[^\u1000-\u109F])(?:[\u1000-\u109F]+(\s*[\u1000-\u109F]+)*)+(?=$|[^\u1000-\u109F])/) { |b| fmt(b, FONT) }
  end.join("\n")

  File.open("new/#{dt.strftime("%Y-%m-%d")}-#{title.gsub(/\s/, "-").downcase}.md", "w") do |f|
    f.puts formatted_post
  end

  #exit
end
