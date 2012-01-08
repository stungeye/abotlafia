# encoding: UTF-8
not_now = rand(10) > 3
exit if not_now

require 'rubygems'
require 'chatterbot/dsl'
require "sequel"
require "./db_connect.rb"

# debug_mode
no_update

DB = Sequel.connect("mysql2://#{DB_USER}:#{DB_PASSWORD}@localhost/stungeye")
random_sentence = DB.fetch("SELECT * FROM `sentences` WHERE `tweeted` = FALSE ORDER BY RAND() LIMIT 1").first
DB[:sentences].where(:id => random_sentence[:id]).update(:tweeted => true)
tweet random_sentence[:words]
