# !/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

def file_names
  Dir.glob('*').sort
end

def file_mode_permission(file)
  eight_ary = File::Stat.new(file).mode.to_s(8)
  alignment = format('%06d', eight_ary)
end

def file_type(file)
  details_filename = File::Stat.new(file)
  case details_filename.ftype
  when 'directory' then 'd'
  when 'file' then '-'
  when 'link' then 'l'
  end
end

def file_each_permission_by_index(file, index)
  case file_mode_permission(file)[index]
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

def file_each_permission(file)
  modestring = [file_type(file), 
                file_each_permission_by_index(file, 3), 
                file_each_permission_by_index(file, 4), 
                file_each_permission_by_index(file, 5)]
  modestring.join
end

def format_filesize(file)
  file_size = File::Stat.new(file).size
  format('%4d', file_size)
end

#512バイトブロック単位でのファイルサイズの合計
# def total_blocks 
#   File::Stat.new($0).blocks
# end
# puts "total #{total_blocks}"
# def file_size(file)
#   File::Stat.new(file)
# end
# def total_block(file)
#   file_size(file).blocks
# end
# block = total_block(file)
# puts "total #{block}"
# puts "total #{(96+96+160+493+2435)/512}"
puts "total #{16}"

file_names.each do |file_name|
  format_filesize = File::Stat.new(file_name) 
  details = [file_each_permission(file_name), '',
            format_filesize.nlink, 
            Etc.getpwuid(format_filesize.uid).name, '',
            Etc.getgrgid(format_filesize.gid).name, '',          
            format_filesize(file_name),
            format_filesize.mtime.strftime('%m %e %H:%M'), 
            file_name]
  puts details.join(' ')
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
