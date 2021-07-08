#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  @opt = ARGV.getopts('l')
  files = ARGV
  if @opt['l']
    puts l_option_output(files)
  elsif @opt['l'] && files.size > 1
    puts l_option_output(files)
    puts total_count(files)
  elsif files.empty?
    puts output_with_pipe(files)
  elsif files.size > 1
    puts standerd_output(files)
    puts total_output(files)
  else
    puts standerd_output(files)
  end
end

def output_with_pipe(_files)
  text = $stdin.read
  lines = text.lines.count
  words = text.split(/\s+/).size
  bytes = text.size
  [] << [
    lines.to_s.rjust(8),
    words.to_s.rjust(8),
    bytes.to_s.rjust(8)
  ].join('')
end

def standerd_output(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    words = text.split(/\s+/).size
    bytes = File.new(file).size
    name = File.basename(file)
    [] << [
      lines.to_s.rjust(8),
      words.to_s.rjust(8),
      bytes.to_s.rjust(8),
      " #{name}"
    ].join('')
  end
end

def total(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    words = text.split(/\s+/).size
    bytes = File.new(file).size
    if @opt['l']
      [] << lines
    else
      [] << lines << words << bytes
    end
  end
end

def total_output(files)
  total_count = total(files).transpose.map { |a| a.inject(:+) }
  total_with_space = total_count.map do |number|
    number.to_s.rjust(8)
  end
  "#{total_with_space.join('')} total"
end

def l_option_output(_files)
  text = $stdin.read
  lines = text.lines.count
  [] << [
    lines.to_s.rjust(8)
  ].join('')
end

main
