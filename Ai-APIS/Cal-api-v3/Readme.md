Sure! Here is a `README.md` file for the Ruby script `generate_invite.rb` which creates an iCalendar (.ics) file for meeting invites.

### README.md

```markdown
# iCalendar Invite Generator

This Ruby script generates an iCalendar (.ics) file for a meeting invite based on the provided command-line arguments. The resulting .ics file can be used to send calendar invitations that are compatible with most calendar applications, including Google Calendar, Outlook, and Apple Calendar.

## Prerequisites

- Ruby 2.0 or higher

## Usage

To use the script, run it with the appropriate command-line arguments. The following arguments are required:

- `-t` : Event title
- `-d` : Event description
- `-s` : Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time)
- `-e` : Event end time (format: 'YYYY-MM-DD HH:MM:SS', local time)
- `-l` : Event location
- `-o` : Organizer email (format: 'Name <email@example.com>')
- `-a` : Attendee email (format: 'Name <email@example.com>')
- `-z` : Time zone (e.g., 'PST', 'PDT')
- `-f` : Output filename (e.g., meeting_invite.ics)

### Example

```bash
./generate_invite.rb -t "Project Meeting" -d "Discuss project milestones and deliverables." -s "2024-06-24 13:00:00" -e "2024-06-24 14:00:00" -l "Conference Room A" -o "John Doe <john.doe@example.com>" -a "Jane Smith <jane.smith@example.com>" -z "PST" -f "meeting_invite.ics"
```

## Installation

1. Ensure you have Ruby installed on your system. You can check by running:
    ```bash
    ruby -v
    ```

2. Save the script as `generate_invite.rb`.

3. Make the script executable:
    ```bash
    chmod +x generate_invite.rb
    ```

## Script Details

The script does the following:

1. **Option Parsing**: Uses `OptionParser` to parse command-line arguments.
2. **Time Conversion**: Converts the provided start and end times to UTC using the specified time zone.
3. **UID Generation**: Uses `SecureRandom.uuid` to generate a unique identifier for the event.
4. **File Creation**: Constructs the iCalendar file and writes it to the specified filename.

## Time Zone Handling

- **PST (Pacific Standard Time)**: Use `PST` for handling both PST and PDT (Pacific Daylight Time), which adjusts for daylight saving time automatically.
- **Other Time Zones**: Replace `"PST"` with the appropriate time zone identifier (e.g., `"EST"` for Eastern Standard Time).

## Example Output

The script generates an .ics file with the following structure:

```plaintext
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Your Organization//Your Product//EN
METHOD:REQUEST
BEGIN:VEVENT
UID:unique-identifier
DTSTAMP:20240624T123000Z
ORGANIZER;CN=John Doe:mailto:john.doe@example.com
DTSTART:20240624T130000Z
DTEND:20240624T140000Z
SUMMARY:Project Meeting
DESCRIPTION:Discuss project milestones and deliverables.
LOCATION:Conference Room A
STATUS:CONFIRMED
TRANSP:OPAQUE
SEQUENCE:0
BEGIN:VALARM
TRIGGER:-PT15M
REPEAT:1
DURATION:PT15M
ACTION:DISPLAY
DESCRIPTION:Reminder: Project Meeting starts in 15 minutes
END:VALARM
ATTENDEE;CN=Jane Smith;RSVP=TRUE;PARTSTAT=NEEDS-ACTION;ROLE=REQ-PARTICIPANT:mailto:jane.smith@example.com
END:VEVENT
END:VCALENDAR
```

## Notes

- Ensure the time zone provided matches your local time zone to avoid discrepancies in the event timing.
- The script generates a unique UID for each event to avoid conflicts with other calendar entries.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

```

This `README.md` file provides clear instructions on how to use the Ruby script, including prerequisites, usage examples, installation steps, and an explanation of the script's functionality. Adjust the script and `README.md` as needed for your specific use case.


### Documentation for Generating iCalendar (.ics) Files

This documentation provides instructions on how to use a Ruby script to generate iCalendar (.ics) files for scheduling events, suitable for sending meeting invites and calendar entries.

#### Prerequisites

1. **Ruby Installation**: Ensure Ruby is installed on your system.
2. **Required Gems**: Ensure `optparse` gem is installed (`gem install optparse`) for command-line option parsing.

#### Script Overview

The provided Ruby script (`generate_calendar.rb`) generates an iCalendar (.ics) file based on user input for event details. It includes features such as time zone handling and attendee notifications.

#### Usage

```bash
ruby generate_calendar.rb -t TITLE -d DESCRIPTION -s START -e END -l LOCATION -o ORGANIZER -a ATTENDEE -z TIMEZONE -f FILENAME
```

- **-t TITLE**: Event title.
- **-d DESCRIPTION**: Event description.
- **-s START**: Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time).
- **-e END**: Event end time (format: 'YYYY-MM-DD HH:MM:SS', local time).
- **-l LOCATION**: Event location.
- **-o ORGANIZER**: Organizer email (format: 'Name <email@example.com>').
- **-a ATTENDEE**: Attendee email (format: 'Name <email@example.com>').
- **-z TIMEZONE**: Time zone abbreviation (e.g., 'PST', 'PDT').
- **-f FILENAME**: Output filename for the .ics file.

#### Example

```bash
ruby generate_calendar.rb \
  -t "Team Meeting" \
  -d "Weekly team meeting to discuss project updates." \
  -s "2024-06-25 10:00:00" \
  -e "2024-06-25 11:00:00" \
  -l "Conference Room A" \
  -o "John Doe <john.doe@example.com>" \
  -a "Jane Smith <jane.smith@example.com>" \
  -z "PST" \
  -f "team_meeting.ics"
```

#### Script Details

1. **Parsing Command-Line Options**: Uses `optparse` to parse and validate command-line arguments.
2. **Time Conversion**: Converts event start and end times to UTC format for compatibility across different time zones.
3. **Creating .ics File**: Generates an iCalendar file with event details including title, description, location, organizer, attendee, and a reminder alarm.

#### Output

- The script creates an iCalendar file (`team_meeting.ics` in the example) in the current directory based on the provided options.

#### Notes

- Ensure all required options (`-t`, `-d`, `-s`, `-e`, `-l`, `-o`, `-a`, `-z`, `-f`) are provided to successfully generate the .ics file.
- The script includes a reminder alarm set to notify attendees 15 minutes before the event starts.

#### Conclusion

This script simplifies the process of generating iCalendar (.ics) files for scheduling events, ensuring compatibility with calendar applications that support the iCalendar format. Adjust options and details according to specific event requirements and preferences.

### README for make-schedule.rb

## Overview

`make-schedule.rb` is a Ruby script designed to create and manage events in an iCalendar (.ics) file. The script allows users to add multiple events with specified titles, start times, locations, and output them into a single `.ics` file. The script also supports appending new events to an existing `.ics` file and correctly formatting the iCalendar file for compatibility with most calendar applications.

## Features

- Add multiple events to a single iCalendar (.ics) file.
- Specify event titles, start times, and locations.
- Append events to an existing iCalendar file.
- Ensure correct iCalendar formatting with `BEGIN:VCALENDAR` and `END:VCALENDAR` tags.

## Prerequisites

- Ruby (>= 2.0)
- `optparse` (comes standard with Ruby)

## Usage

### Command-line Options

- `-t TITLE`: Event title
- `-s START`: Event start time (format: 'YYYY-MM-DD HH:MM:SS', local time)
- `-l LOCATION`: Event location
- `-f FILENAME`: Output filename for the iCalendar (.ics) file
- `-e`: End of input (optional, use at the end of the command to close the iCalendar file)

### Example Command

To add multiple events to an iCalendar file:

```sh
ruby make-schedule.rb -t "Meeting 1" -s "2024-06-30 18:00:00" -l "Conference Room" -f calendar.ics \
                     -t "Meeting 2" -s "2024-07-01 10:00:00" -l "Office" -f calendar.ics \
                     -e
```

This command will:
1. Add an event titled "Meeting 1" starting at "2024-06-30 18:00:00" in "Conference Room" to `calendar.ics`.
2. Add another event titled "Meeting 2" starting at "2024-07-01 10:00:00" in "Office" to the same `calendar.ics` file.
3. Close the iCalendar file with the `END:VCALENDAR` tag.

### Detailed Steps

1. **Add Event 1:**
   - Title: "Meeting 1"
   - Start Time: "2024-06-30 18:00:00"
   - Location: "Conference Room"
   - Output File: `calendar.ics`

2. **Add Event 2:**
   - Title: "Meeting 2"
   - Start Time: "2024-07-01 10:00:00"
   - Location: "Office"
   - Output File: `calendar.ics`

3. **End of Input:**
   - Signal the end of input with `-e` to close the iCalendar file with `END:VCALENDAR`.

### Script Details

The script uses `optparse` to handle command-line arguments and ensures that all necessary fields are provided. Events are appended to the specified `.ics` file, and the script ensures correct formatting by adding the required `BEGIN:VCALENDAR` and `END:VCALENDAR` tags.

### Example .ics File

After running the example command, the `calendar.ics` file will look like this:

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Your Organization//Your Product//EN
BEGIN:VEVENT
UID:generated-uuid-1
DTSTAMP:20240625T171401Z
DTSTART:20240630T180000Z
SUMMARY:Meeting 1
LOCATION:Conference Room
END:VEVENT
BEGIN:VEVENT
UID:generated-uuid-2
DTSTAMP:20240625T171401Z
DTSTART:20240701T170000Z
SUMMARY:Meeting 2
LOCATION:Office
END:VEVENT
END:VCALENDAR
```

## Troubleshooting

- **File Not Opening in Calendar App:** Ensure that the `.ics` file is correctly formatted with `BEGIN:VCALENDAR` at the start and `END:VCALENDAR` at the end.
- **Incorrect Time Formatting:** Make sure the start time is provided in the format 'YYYY-MM-DD HH:MM:SS' and matches the local time.
- **Dependencies Missing:** Ensure Ruby is installed on your system.

## Contribution

Feel free to fork the repository and submit pull requests. Any improvements or additional features are welcome!

## License

This project is licensed under the MIT License.

---

This detailed README should provide a comprehensive guide to using the `make-schedule.rb` script, ensuring users can effectively create and manage iCalendar files with multiple events.