require 'optparse'
require 'time'
require 'securerandom'

# Function to display usage
def usage
  puts "Usage: #{$0} -t TITLE -d DESCRIPTION -s START -e END -l LOCATION -o ORGANIZER -a ATTENDEE -z TIMEZONE -f FILENAME"
  puts "  -t TITLE       : Event title"
  puts "  -d DESCRIPTION : Event description"
  puts "  -s START       : Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time)"
  puts "  -e END         : Event end time (format: 'YYYY-MM-DD HH:MM:SS', local time)"
  puts "  -l LOCATION    : Event location"
  puts "  -o ORGANIZER   : Organizer email (format: 'Name <email@example.com>')"
  puts "  -a ATTENDEE    : Attendee email (format: 'Name <email@example.com>')"
  puts "  -z TIMEZONE    : Time zone (e.g., 'PST', 'PDT')"
  puts "  -f FILENAME    : Output filename (e.g., meeting_invite.ics)"
  exit 1
end

options = {}
OptionParser.new do |opts|
  opts.on("-t TITLE", "Event title") { |v| options[:title] = v }
  opts.on("-d DESCRIPTION", "Event description") { |v| options[:description] = v }
  opts.on("-s START", "Event start time") { |v| options[:start] = v }
  opts.on("-e END", "Event end time") { |v| options[:end] = v }
  opts.on("-l LOCATION", "Event location") { |v| options[:location] = v }
  opts.on("-o ORGANIZER", "Organizer email") { |v| options[:organizer] = v }
  opts.on("-a ATTENDEE", "Attendee email") { |v| options[:attendee] = v }
  opts.on("-z TIMEZONE", "Time zone") { |v| options[:timezone] = v }
  opts.on("-f FILENAME", "Output filename") { |v| options[:filename] = v }
end.parse!

# Check if all required arguments are provided
if [:title, :description, :start, :end, :location, :organizer, :attendee, :timezone, :filename].any? { |k| options[k].nil? }
  usage
end

# Convert start and end times to UTC format
start_utc = Time.parse(options[:start] + " " + options[:timezone]).utc.strftime("%Y%m%dT%H%M%SZ")
end_utc = Time.parse(options[:end] + " " + options[:timezone]).utc.strftime("%Y%m%dT%H%M%SZ")

# Extract organizer name and email
organizer_name, organizer_email = options[:organizer].match(/^(.*) <(.*)>$/).captures

# Extract attendee name and email
attendee_name, attendee_email = options[:attendee].match(/^(.*) <(.*)>$/).captures

# Generate UID for the event
uid = SecureRandom.uuid

# Create the .ics file
File.open(options[:filename], 'w') do |file|
  file.puts <<~EOF
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//Your Organization//Your Product//EN
    METHOD:REQUEST
    BEGIN:VEVENT
    UID:#{uid}
    DTSTAMP:#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}
    ORGANIZER;CN=#{organizer_name}:mailto:#{organizer_email}
    DTSTART:#{start_utc}
    DTEND:#{end_utc}
    SUMMARY:#{options[:title]}
    DESCRIPTION:#{options[:description]}
    LOCATION:#{options[:location]}
    STATUS:CONFIRMED
    TRANSP:OPAQUE
    SEQUENCE:0
    BEGIN:VALARM
    TRIGGER:-PT15M
    REPEAT:1
    DURATION:PT15M
    ACTION:DISPLAY
    DESCRIPTION:Reminder: #{options[:title]} starts in 15 minutes
    END:VALARM
    ATTENDEE;CN=#{attendee_name};RSVP=TRUE;PARTSTAT=NEEDS-ACTION;ROLE=REQ-PARTICIPANT:mailto:#{attendee_email}
    END:VEVENT
    END:VCALENDAR
  EOF
end

puts "iCalendar file '#{options[:filename]}' created successfully."