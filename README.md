# TodoCmd
TodoCmd is a system for management tasks. The base concept of todo list model is from todo.txt. Native todo.txt is very simple and useful, however, it can be complex if each task contain extra information (e.g. timestamp of add task, tags, memos and etc...). Such kind of information decrease readbility of the list.
TodoCmd helps to write the todo list and manages the list with the task details. 

## Command
todo \<command\> [\<args\>]

If you type "todolist" without any args or sub commands, tasks stored in list file will be displayed.

These are sub commands:

| command | Feature |
| :---: | :--- |
| add | Add tasks to a list |
| done | Change status of a task done |
| cancel | Change status of a task cancel. This command may be used in case the task no longer need to do |
