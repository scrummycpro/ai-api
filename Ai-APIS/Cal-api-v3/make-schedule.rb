#!/usr/bin/env ruby
require 'optparse'
require 'time'
require 'securerandom'

# Function to display usage
def usage
  puts "Usage: #{$0} -t TITLE -s START -l LOCATION -f FILENAME [-e]"
  puts "  -t TITLE       : Event title"
  puts "  -s START       : Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time)"
  puts "  -l LOCATION    : Event location"
  puts "  -f FILENAME    : Output filename for the iCalendar (.ics) file"
  puts "  -e             : End of input (optional, use at the end of the command)"
  exit 1
end

options = []
end_calendar = false
filename = nil
calendar_header_written = false

OptionParser.new do |opts|
  opts.on("-t TITLE", "Event title") { |v| options << { title: v } }
  opts.on("-s START", "Event start time") { |v| options.last[:start] = v }
  opts.on("-l LOCATION", "Event location") { |v| options.last[:location] = v }
  opts.on("-f FILENAME", "Output filename for iCalendar file") { |v| filename = v; options.last[:filename] = v }
  opts.on("-e", "End of input") { end_calendar = true }
end.parse!

# Check if all required arguments are provided
if options.empty? || options.any? { |opt| opt[:title].nil? || opt[:start].nil? || opt[:location].nil? }
  usage
end

# Create or append to the .ics file for each event
File.open(filename, 'a') do |file|
  unless calendar_header_written
    file.puts "BEGIN:VCALENDAR"
    file.puts "VERSION:2.0"
    file.puts "PRODID:-//Your Organization//Your Product//EN"
    calendar_header_written = true
  end

  options.each do |opt|
    # Convert start time to UTC format
    start_time = Time.parse(opt[:start])
    start_utc = start_time.utc.strftime("%Y%m%dT%H%M%SZ")

    # Generate UID for the event
    uid = SecureRandom.uuid

    # Write the event to the .ics file
    file.puts <<~EOF
      BEGIN:VEVENT
      UID:#{uid}
      DTSTAMP:#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}
      DTSTART:#{start_utc}
      SUMMARY:#{opt[:title]}
      LOCATION:#{opt[:location]}
      END:VEVENT
    EOF
  end

  file.puts "END:VCALENDAR" if end_calendar
end

puts "iCalendar file '#{filename}' updated with new events."