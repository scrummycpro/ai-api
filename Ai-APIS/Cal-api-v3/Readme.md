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