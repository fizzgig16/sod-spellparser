#!/usr/bin/env ruby

require 'sqlite3'

f = File.open("/tmp/foo.txt", "r")
db = SQLite3::Database.new("db/development.sqlite3")

f.each do | line |
	data = /case (.*?): skillType = \"(.*?)\";/.match(line)
	#puts(data[1] + "|" + data[2]) if data != nil
	db.execute("insert into skill_types (id, name) values('" + data[1] + "','" + data[2] + "')") if data != nil
end
