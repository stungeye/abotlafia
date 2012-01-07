# encoding: UTF-8

require "rubygems"
require "bundler/setup"
require "sequel"
require "./db_connect.rb"
require 'logger'

#DB = Sequel.connect("mysql2://#{DB_USER}:#{DB_PASSWORD}@localhost/stungeye", :loggers => [Logger.new($stdout)])
DB = Sequel.connect("mysql2://#{DB_USER}:#{DB_PASSWORD}@localhost/stungeye")

total_sentences = DB[:sentences].count
puts "There are #{total_sentences} sentences."
random_sentence = DB.fetch("SELECT * FROM `sentences` WHERE `tweeted` = FALSE ORDER BY RAND() LIMIT 1").first

puts "Random Sentence:"
puts random_sentence[:words]
DB[:sentences].where(:id => random_sentence[:id]).update(:tweeted => true)

total_tweeted = DB[:sentences].where(:tweeted => true).count
puts "Total Tweeted: #{total_tweeted}"