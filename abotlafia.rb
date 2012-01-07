# encoding: UTF-8
not_now = rand(10) > 4
exit if not_now

require 'rubygems'
require 'chatterbot/dsl'
require "sequel"
require "./db_connect.rb"

# remove this to send out tweets
# debug_mode

# remove this to update the db
no_update
# remove this to get less output when running
# verbose

# here's a list of users to ignore
# blacklist "abc", "def"

# here's a list of things to exclude from searches
# exclude "hi", "spammer", "junk"

# search "keyword" do |tweet|
#  reply "Hey #USER# nice to meet you!", tweet
# end

# replies do |tweet|
#   reply "Yes #USER#, you are very kind to say that!", tweet
# end

DB = Sequel.connect("mysql2://#{DB_USER}:#{DB_PASSWORD}@localhost/stungeye")
random_sentence = DB.fetch("SELECT * FROM `sentences` WHERE `tweeted` = FALSE ORDER BY RAND() LIMIT 1").first
DB[:sentences].where(:id => random_sentence[:id]).update(:tweeted => true)
tweet random_sentence[:words]
