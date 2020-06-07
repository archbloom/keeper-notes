# README
A note keeper application where you can put your ideas and take action on them.

* Ruby version - 2.4.4
* Rails version - 5.0.7.2

### Roles available
- Owner - *Creator* of the note
- Reader - can *Read* - access provided access by Owner
- Collaborator - can *Read* and *Update* - access provided access by Owner

### Setup
- Ruby version - 2.4.4
- Rails version - 5.0.7.2
- sqlite3 as database
- rake db:setup

### Flow
- When the user sign up, initially has no role.
- When user creates a note, user becomes *owner* of the note.
- Note can have one or more tags
- Owner can share the note with specific access(Reader or Collaborator) with other users
- On note's show page there is a table of all the users and from the Owner can provide the access to others
- On index page there are two tabs, *My Notes* and *Shared Notes*
  - In *My Note* tab, user can see the notes created by him/her.
  - In *Shared Notes* tab, user can see the notes which are shared with him/her.

### Future scope
- Reader role should be able to add comment on Note
- Reader role can ask for collaborator permission
- Add type of note, *Idea* or *Task*
- For task, add task *reminder*, add task *end date*, add *priority to the task*
- Add check list(same as ToDo list)
- Add Export notes functionality (CSV at first)
- Add Import notes functionality (CSV at first)

### Constraints
- SQLITE3 for the database
- Only owner can share the notes
- Collaborator can read and update, can not share the note
- Reader can read the shared notes
