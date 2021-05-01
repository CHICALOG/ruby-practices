# !/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

def file_names
  Dir.glob('*').sort
end

def octal_permission(file)
  octal_mode = File::Stat.new(file).mode.to_s(8)
  octal_mode[-3..-1]
end

def file_type(file)
  case File::Stat.new(file).ftype
  when 'directory' then 'd'
  when 'file' then '-'
  when 'link' then 'l'
  end
end

def permission_by_index(file, index)
  case octal_permission(file)[index]
  when '0' then '---'
  when '1' then '--x'
  when '2' then '-w-'
  when '3' then '-wx'
  when '4' then 'r--'
  when '5' then 'r-x'
  when '6' then 'rw-'
  when '7' then 'rwx'
  end
end

def type_and_permission(file)
  file_type(file) +
    permission_by_index(file, 0) +
    permission_by_index(file, 1) +
    permission_by_index(file, 2)
end

def file_stat(file)
  file_size = File::Stat.new(file).size
  format('%4d', file_size)
end

total = 0
file_names.each do |file_name|
  file_stat = File::Stat.new(file_name)
  total += file_stat.blocks
end
puts "total #{total}"

file_names.each do |file_name|
  file_stat = File::Stat.new(file_name)
  details = "#{type_and_permission(file_name)} " \
            "#{file_stat.nlink} " \
            "#{Etc.getpwuid(file_stat.uid).name} " \
            "#{Etc.getgrgid(file_stat.gid).name} " \
            "#{file_stat(file_name)} " \
            "#{file_stat.mtime.strftime('%m %e %H:%M')} " \
            "#{file_name} "
  puts details
end

# TAB_WIDTH = 8
# COLUMN_COUNT = 3

# file_names = Dir.glob("*").sort
# file_names = Dir.glob("*").sort.reverse #-r
# file_names = Dir.glob("*", File::FNM_DOTMATCH).sort #-a
# file_names = Dir.glob("*", File::FNM_DOTMATCH).sort.reverse #-ar

# longest_file_name = file_names.max_by(&:size).size
# width = TAB_WIDTH * (longest_file_name / TAB_WIDTH.to_f).ceil

# formatted_file_names = file_names.map {|file_name| file_name.ljust(width)}

# row_count = (file_names.size.to_f / COLUMN_COUNT).ceil
# nested_file_names = formatted_file_names.each_slice(row_count).to_a

# nested_file_names = nested_file_names.map {|inner_file_names| inner_file_names.values_at(0...row_count)}
# nested_file_names.transpose.each do |file|
#   puts file.join(' ')
# end
