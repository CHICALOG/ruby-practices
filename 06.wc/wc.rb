#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  @opt = ARGV.getopts('l')
  files = ARGV
  if @opt['l']
    puts l_option_output_files(files)
  else
    puts standard_output_files(files)
  end
end

def standard_output_files(_files)
  text = $stdin.read
  lines = text.lines.count
  words = text.split(/\s+/).length
  bytes = text.length
  [] << [
    lines.to_s.rjust(8),
    words.to_s.rjust(8),
    bytes.to_s.rjust(8)
  ].join('')
end

def l_option_output_files(_files)
  text = $stdin.read
  lines = text.lines.count
  [] << [
    lines.to_s.rjust(8)
  ].join('')
end

main
