# encoding: UTF-8
#
# Quick and dirty way to parse out a bunch of tweet sized
# strings from our corpus.

require "rubygems"
require "bundler/setup"
require "sequel"
require "./db_connect.rb"

def fixit(sentence)
  while ['”','’','‘','—',')',','].include?(sentence[0])
    sentence = sentence[1,sentence.size-1]
    sentence.strip!
  end
  sentence.capitalize!
  if sentence.count('“') > sentence.count('”')
    sentence += '”'
  end
  if sentence.count('“') < sentence.count('”')
    sentence = '“' + sentence
  end
  if sentence.count('‘') > sentence.count('’')
    sentence += '’'
  end
  if sentence.count('(') > sentence.count(')')
    sentence += ')'
  end
  sentence
end

# Read the entire file into a single string, ensure that line-ending
# are padding with extra spaces.

corpus = ''
open('pendulum.txt', 'r:UTF-8') do |file|
  file.each do |line|
    corpus += line.strip + ' '
  end
end

accepted = []
rejected = []

# Split the corpus on periods, so we may get multiple sentences per split
# depending on the punctuation. 
# Accepted senteces will be tweet sized, but longer than 15 chars. 

corpus.split('.').map{ |s| s.strip }.select{ |s| s.size > 0 }.each do |sentence|
  sentence += '.'
  sentence = fixit(sentence)
  accepted << sentence  if sentence.size > 15 && sentence.size <= 140
  rejected << sentence  if sentence.size > 140
end

# Of the rejected setences split again on question marks. See if any of these
# newly split setences are tweet-sized and reject the rest.

more_rejects = []
rejected.each do |reject|
  reject.split('?').map{|s| s.strip }.select{ |s| s.size > 0 }.each do |sentence|
    sentence += '?'  unless sentence[-1] == '.'
    sentence = fixit(sentence)
    accepted << sentence  if sentence.size > 15 && sentence.size <= 140
    more_rejects << sentence  if sentence.size > 140
  end
end

rejected = more_rejects

DB = Sequel.connect("mysql2://#{DB_USER}:#{DB_PASSWORD}@localhost/stungeye")
sentences = DB[:sentences]

open('sentences.txt', 'w:UTF-8') do |file|
  accepted.each do |sentence|
    # file.puts "#{sentence} (#{sentence.size})"
    sentences.insert( :words => sentence, :length => sentence.size )
  end
end

puts "Accepted: #{accepted.size}"
puts "Rejected: #{rejected.size}"
