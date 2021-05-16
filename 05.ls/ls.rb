# !/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

TAB_WIDTH = 8
COLUMN_COUNT = 3

FILE_TYPE = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l'
}.freeze

LOCAL_PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  opt = ARGV.getopts('a', 'r', 'l')

  file_names = if opt['a']
                 Dir.glob('*', File::FNM_DOTMATCH).sort
               else
                 Dir.glob('*').sort
               end

  file_names = file_names.reverse if opt['r']

  if opt['l']
    ls_command_with_l_option(file_names)
  else
    ls_command_without_l_option(file_names)
  end
end

def ls_command_without_l_option(file_names)
  longest_file_name = file_names.max_by(&:size).size
  width = TAB_WIDTH * (longest_file_name / TAB_WIDTH.to_f).ceil

  formatted_file_names = file_names.map { |file_name| file_name.ljust(width) }

  row_count = (file_names.size.to_f / COLUMN_COUNT).ceil
  nested_file_names = formatted_file_names.each_slice(row_count).to_a

  nested_file_names = nested_file_names.map { |inner_file_names| inner_file_names.values_at(0...row_count) }
  nested_file_names.transpose.each do |file|
    puts file.join(' ')
  end
end

def ls_command_with_l_option(file_names)
  total = 0
  file_names.each do |file_name|
    file_stat = File::Stat.new(file_name)
    total += file_stat.blocks
  end
  puts "total #{total}"

  file_names.each do |file_name|
    file_stat = File::Stat.new(file_name)
    details = "#{type_and_permission(file_name)} " \
              "#{file_stat_nlink(file_name)} " \
              "#{Etc.getpwuid(file_stat.uid).name} " \
              "#{Etc.getgrgid(file_stat.gid).name} " \
              "#{format_filesize(file_name)} " \
              "#{file_stat.mtime.strftime('%m %d %H:%M')} " \
              "#{file_name} "
    puts details
  end
end

def ocal_permission(file)
  octal_mode = File::Stat.new(file).mode.to_s(8)
  octal_mode[-3..]
end

def file_type(file)
  type = File::Stat.new(file).ftype
  FILE_TYPE[type]
end

def permission_by_index(file, index)
  type = ocal_permission(file)[index]
  LOCAL_PERMISSION[type]
end

def type_and_permission(file)
  file_type(file) +
    permission_by_index(file, 0) +
    permission_by_index(file, 1) +
    permission_by_index(file, 2)
end

def file_stat_nlink(file)
  file_nlink = File::Stat.new(file).nlink
  format('%2d', file_nlink)
end

def format_filesize(file)
  file_size = File::Stat.new(file).size
  format('%4d', file_size)
end

main
