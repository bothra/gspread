require "rubygems"
require "google_drive"
require 'net/scp'

# retrieve files

    host1 = 'spruce.pcbi.upenn.edu'
    login = 'mguidry'
    Net::SCP.start(host1, login) do |scp|
      scp.download('bandwidth_from_uga.csv', '.')
      scp.download('bandwidth_to_uga.csv', '.')
      scp.download('bandwidth_from_ca.csv', '.')
      scp.download('bandwidth_to_ca.csv', '.')
    end



# Google Spreadsheet
session = GoogleDrive.login("mguidry@apidb.org", "d0l3m1t3!")

# Download Worksheet
dl = session.spreadsheet_by_key("0Akco2GpW4xOkdEs0aFJUVjhwT3pJQmN0OTVwQzlzTEE").worksheets[0]

rowd = File.open('bandwidth_from_uga.csv'){|f| f.readlines.map{|p| p.strip.split(",")}}

rowd.each do |row|
    st = dl.num_rows + 1
    dl[st,1] = row[0]
    dl[st,2] = row[1]
    dl.save()
end


# Upload Worksheet 
ul = session.spreadsheet_by_key("0Akco2GpW4xOkdEs0aFJUVjhwT3pJQmN0OTVwQzlzTEE").worksheets[1]

rowu = File.open('bandwidth_to_uga.csv'){|f| f.readlines.map{|p| p.strip.split(",")}}

rowu.each do |row|
    st = ul.num_rows + 1
    ul[st,1] = row[0]
    ul[st,2] = row[1]
    ul.save()
end

# shiro to loquat
dl2 = session.spreadsheet_by_key("0Akco2GpW4xOkdEs0aFJUVjhwT3pJQmN0OTVwQzlzTEE").worksheets[2]

rowd2 = File.open('bandwidth_from_ca.csv'){|f| f.readlines.map{|p| p.strip.split(",")}}

rowd2.each do |row|
    st = dl2.num_rows + 1
    dl2[st,1] = row[0]
    dl2[st,2] = row[1]
    dl2.save()
end

# loquat to shiro
ul2 = session.spreadsheet_by_key("0Akco2GpW4xOkdEs0aFJUVjhwT3pJQmN0OTVwQzlzTEE").worksheets[3]

rowu2 = File.open('bandwidth_to_ca.csv'){|f| f.readlines.map{|p| p.strip.split(",")}}

rowu2.each do |row|
    st = ul2.num_rows + 1
    ul2[st,1] = row[0]
    ul2[st,2] = row[1]
    ul2.save()
end

# remove originals

    Net::SSH.start(host1, login) do |ssh|
      ssh.exec "rm bandwidth_from_uga.csv"
      ssh.exec "rm bandwidth_to_uga.csv"
      ssh.exec "rm bandwidth_from_ca.csv"
      ssh.exec "rm bandwidth_to_ca.csv"
    end
