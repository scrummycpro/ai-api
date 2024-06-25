require 'optparse'
require 'time'
require 'securerandom'

# Function to display usage
def usage
  puts "Usage: #{$0} -t TITLE -s START -d DURATION -f FILENAME"
  puts "  -t TITLE       : Event title"
  puts "  -s START       : Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time)"
  puts "  -d DURATION    : Event duration in minutes"
  puts "  -f FILENAME    : Output filename (e.g., meeting_invite.ics)"
  exit 1
end

options = {}
OptionParser.new do |opts|
  opts.on("-t TITLE", "Event title") { |v| options[:title] = v }
  opts.on("-s START", "Event start time") { |v| options[:start] = v }
  opts.on("-d DURATION", "Event duration in minutes") { |v| options[:duration] = v.to_i }
  opts.on("-f FILENAME", "Output filename") { |v| options[:filename] = v }
end.parse!

# Check if all required arguments are provided
if [:title, :start, :duration, :filename].any? { |k| options[k].nil? }
  usage
end

# Convert start time to UTC format
start_time = Time.parse(options[:start])
start_utc = start_time.utc.strftime("%Y%m%dT%H%M%SZ")

# Calculate end time based on duration
end_time = start_time + (options[:duration] * 60)
end_utc = end_time.utc.strftime("%Y%m%dT%H%M%SZ")

# Generate UID for the event
uid = SecureRandom.uuid

# Create the .ics file
File.open(options[:filename], 'w') do |file|
  file.puts <<~EOF
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//Example Corp//Example Product//EN
    BEGIN:VEVENT
    UID:#{uid}
    DTSTAMP:#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}
    DTSTART:#{start_utc}
    DTEND:#{end_utc}
    SUMMARY:#{options[:title]}
    END:VEVENT
    END:VCALENDAR
  EOF
end

puts "iCalendar file '#{options[:filename]}' created successfully."