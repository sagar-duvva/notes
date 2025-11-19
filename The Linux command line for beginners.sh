##### The Linux command line for beginners -- from ubuntu #####  (https://ubuntu.com/tutorials/command-line-for-beginners)

# Descriptions, content
? Notes, Ideas, Tips


# pwd is an abbreviation of ‘print working directory’.
pwd             # Prints current working directory.

# You can change the working directory using the cd command, an abbreviation for ‘change directory’. Try typing the following:
cd /            # Now your working directory is “/”. 
cd home         # moved you into the “home” directory (which is an immediate subdirectory of “/”) 
cd ..           # To go up to the parent directory. Basically One step above directory from “home” directory back to "Root" directory

cd              # Typing cd on its own is a quick shortcut to get back to your home directory (User Home Directory "/home/user").
#OR#
cd ~

cd ../..        # You can also use .. more than once if you have to move up through multiple levels of parent directories:
cd

cd ../../etc    # So if we wanted to go straight from our home directory to the “etc” directory
#OR#
cd /etc         # Directly swtich directory to “etc” directory


cd /etc ~/Desktop # Changing multiple directories at once will not work, will give out error.

################# Creating folders and files

mkdir dir1 dir2 dir3        # mkdir is short for ‘make directory’. mkdir can create multiple directories at once, In this case mkdir will create 3 directories.
ls                          # ls (list) command, lists all content of current directory.
mkdir -p dir4/dir5/dir6     # mkdir will create "dir6" directory inside of "dir5" inside of "dir4"
# The “-p” that we used is called an option or a switch (in this case it means “create the parent directories, too”). 
# Don't type these in, they're just here for demonstrative purposes
#mkdir --parents --verbose dir4/dir5
#mkdir -p --verbose dir4/dir5
#mkdir -p -v dir4/dir5
mkdir -pv dir4/dir5         # mkdir will create "dir5" directory inside of "dir4" while giving verbose output of each step/operation
mkdir another folder        # mkdir will create two new directories, one called "another" and the other called "folder".
mkdir "folder 1"            # mkdir will create "folder 1" directory with space in between
mkdir 'folder 2'            # mkdir will create "folder 2" directory with space in between
mkdir folder\ 3             # mkdir will create "folder 3" directory with space in between
mkdir "folder 4" "folder 5" # mkdir will create "folder 4" directory & "folder 5" directory with space in between
mkdir -p "folder 6"/"folder 7"  # mkdir will create "folder 7" directory inside of "folder 6" directory
??? suggested to use underscores (“_”) or hyphens (“-”) instead of spaces in files/folders names.


################# Creating files using redirection

ls > output.txt     # capture the output of that command as a text file by adding the greater-than character (“>”) to the end of our command line, followed by the name of the file to write to.
cat output.txt          # use "cat" command to look at file content
echo "This is a test"   # echo just prints its arguments back out again (hence the name).
echo "This is a test" > test_1.txt          # capture the output of "echo" command as a text file "text_1.txt"
echo "This is a second test" > test_2.txt
echo "This is a third test" > test_3.txt
ls                       # ls (list) command, lists all content of current directory.

cat test_1.txt test_2.txt test_3.txt        # "cat" name comes from ‘concatenate’, meaning “to link together”. If you pass multiple filename to cat it will output all one after other, as a single block of text.



cat test_1.txt test_2.txt test_3.txt
cat test_?.txt                              # A question mark (“?”) can be used to indicate “any single character” within the file name
cat test_*                                  # An asterisk (“*”) can be used to indicate “zero or more characters”. These are sometimes referred to as “wildcard” characters


### cat t*, meaning “concatenate all the files whose names start with a t and are followed by zero or more other characters”. Let’s use this capability to join all our files together into a single new file, then view it:

cat t* > combined.txt                       # cat t*, meaning “concatenate all the files whose names start with a t and are followed by zero or more other characters” and output to "combined.txt" file.
cat combined.txt


?? to avoid typing the commands again you can use the Up Arrow and Down Arrow keys to move back and forth through the history of commands you’ve used.

cat t* >> combined.txt              # to append to, rather than replace, the content of the existing files, double up on the greater-than character.
echo "I've appended a line!" >> combined.txt
cat combined.txt

less combined.txt                   # viewing a file through less you can use the Up Arrow, Down Arrow, Page Up, Page Down, Home and End keys to move through your file. press q to quit less.

################# A note about case-sensitivity
? Unix systems are case-sensitive, that is, they consider “A.txt” and “a.txt” to be two different files.

echo "Lower case" > a.txt
echo "Upper case" > A.TXT
echo "Mixed case" > A.txt

??Good naming practice
??When you consider both case sensitivity and escaping, a good rule of thumb is to keep your file names all lower case, with only letters, numbers, underscores and hyphens. 
??For files there’s usually also a dot and a few characters on the end to indicate the type of file it is (referred to as the “file extension”). 
??This guideline may seem restrictive, but if you end up using the command line with any frequency you’ll be glad you stuck to this pattern.



################# Moving and manipulating files

mv combined.txt dir1    # putting our combined.txt file into our dir1 directory, using the mv (move) command
ls dir1

cd dir1 
mv combined.txt ..      # Moving file "combined.txt" back to parent directory a step above directory.

cd ..
mv combined.txt dir1
mv dir1/* .             # single dot " . " represent the current working directory, use “ * ” to match any filename in that directory. move the file back into the current working directory.


mv combined.txt test_* dir3 dir2        # "mv" moved 3 "test_(1,2,3).txt" files, "combined.txt" file & "dir3" directory into "dir2"

mv dir2/combined.txt dir4/dir5/dir6     # "mv" moved "combined.txt" file from "dir2" directory into "dir6" directory of "dir5" of "dir4"
ls dir2
ls dir4/dir5/dir6

cp dir4/dir5/dir6/combined.txt .        # "cp" copy command. creates a copy of "combined.txt" file from "dir6" directory of "dir5" of "dir4" in current directory "."
ls dir4/dir5/dir6
ls

cp combined.txt backup_combined.txt     # creates a copy of "combined.txt" file with new filename "backup_combined.txt" in same directory
ls

mv backup_combined.txt combined_backup.txt  # "mv" renames "backup_combined.txt" filename to "combined_backup.txt" filename, basically "mv" moved file "backup_combined.txt" to same dir with new name "combined_backup.txt"
ls

mv "folder 1" folder_1  # "mv" renames "folder 1" dir to "folder_1"
ls



rm dir4/dir5/dir6/combined.txt combined_backup.txt  # "rm" remove command. removes file "combined_backup.txt" in current dir and file "combined.txt" from "dir4/dir5/dir6"

rmdir folder_*          # "rmdir" remove directory command. removes empty directories. removes empty all directory starting with "folder_" except folder_6 with has folder_7 within it.

rm -r folder_6          # "rm" forcefully remove direcoty "folder_6" with all its content.

?? although rm -r is quick and convenient, its also dangerous. Its safest to explicitly delete files to clear out a directory then cd .. to the parent before using rmdir to remove it.

#!! Warning !!#
#!!  rm doesn’t move files to a folder called “trash” or similar. 
#!!  Instead it deletes them totally, utterly and irrevocably. 
#!! You need to be ultra careful with the parameters you use with rm to make sure you’re only deleting the file(s) you intend to.



################# Linux CheatSheet

wc -l combined.txt          # "wc" word count command if used along with -l , can tell us How many lines are there in "combined.txt" file. 

wc -m combined.txt          # "wc" word count command if used along with -m , tell us how many character are there in  "combined.txt" file. 

wc -w combined.txt          # "wc" word count command if used along with -w , tell us How many words are there in "combined.txt" file. 

ls ~ | wc -l                # piping one command output into another as input by using vertical bar "pipe: character (“|”). 

ls /etc|wc -l               # this time for telling us how many items are in the /etc directory

ls /etc | less 


cat combined.txt | uniq | wc -l     # "uniq" Uniq command reports or omits repeated lines... see man page "man uniq"
cat combined.txt | uniq | less      

sort combined.txt                   # "sort" command sort lines of text files... see man page "man sort"
sort combined.txt | uniq | wc -l    


?? checkout man pages of commands like "man ls", "man cp", "man rmdir", and of course "man man".


################# The command line and the superuser

#!! Warning !!#
#!!  Don’t use the root account
#!!  If anyone asks you to enable the root account, or log in as root, be very suspicious of their intentions.


su username     # switch to user "username", your entire terminal session is switched to the other user "username".
sudo            # as in “switch user and do this command”, or simply you can say "super user do"


cat /etc/shadow == gives permission denied error
sudo cat /etc/shadow    # now you are running same command with "sudo" basically means you are running same command as super user

#!! Warning !!#
#!! Be careful with sudo
#!! If you are instructed to run a command with sudo, make sure you understand what the command is doing before you continue. Running with sudo gives that command all the same powers as a superuser


sudo apt install tree   # Let’s install a new command line program from the standard Ubuntu repositories to illustrate this use of sudo

#!! Warning !!#
#!! Indications that files are coming from outside the distribution’s repositories include (but are not limited to) the use of any of the following commands: curl, wget, pip, npm, make, or any instructions that tell you to change a file’s permissions to make it executable.


cd /tmp/tutorial
tree







################# Working with Hidden files

#Before we conclude this tutorial it’s worth mentioning hidden files (and folders). 
#These are commonly used on Linux systems to store settings and configuration data, and are typically hidden simply so that they don’t clutter the view of your own files. 
#There’s nothing special about a hidden file or folder, other than it’s name: simply starting a name with a dot (“.”) is enough to make it disappear.



cd /tmp/tutorial
ls
mv combined.txt .combined.txt       # creating a hidden file named ".combined.txt" by adding "." as a prefex to filename
ls                                  # now file is not visible

cat .combined.txt                   # but you can still view its content
mkdir .hidden                       # creating a hiden directory named ".hidden" by adding prefex "."
mv .combined.txt .hidden            # moving hiden file to hiden folder
less .hidden/.combined.txt          

ls -a                               # to view hidden files and directory lets use "ls" command along with -a
ls .hidden
ls -a .hidden

tree
tree -a                             # similar to ls, -a is used along with tree to view hidden files and directory









################# Logout


logout      # use the logout command, or the Ctrl-D keyboard shortcut to logout from current session.

# If you plan to use the terminal a lot, memorise Ctrl-Alt-T to launch the terminal and Ctrl-D to close it


################# Linux CheatSheet

ps          # "ps" command shows a snapshot of processes.

# The ps command
#This is very simple but powerful command. ps shows a snapshot of processes.

?PID column
#Unique Process Identifier

?TTY column
#Identifies from which the process was spawned

?Time column
#The cumulative CPU time of the process

?Command column
#Identifies which generated that process


ps aux         # 
a
Shows processes attached to a TTY terminal

u
Display user-oriented format

x
Show processes that are not attached to a tty or terminal


%CPU
cpu utilization of the process

ps -eo pid,user,args --sort user

ps aux | grep sshd | grep -v grep

pstree
#The pstree command
#Shows running processes as a tree. This command is very useful as it helps us to easily understand the hierarchies of the processes in our system.

pstree -pa username




################# Linux CheatSheet

################# Linux CheatSheet

pwd             # Prints current working directory.

cd /            # Now your working directory is “/”. 
cd /etc         # Directly swtich directory to “etc” directory
cd ..           # To go up to the parent directory. Basically One step above directory from “home” directory back to "Root" directory

ls              # ls (list) command, lists all content of current directory.

cat output.txt                              # use "cat" command to look at file content
cat test_1.txt test_2.txt test_3.txt        # "cat" name comes from ‘concatenate’, meaning “to link together”. If you pass multiple filename to cat it will output all one after other, as a single block of text.
cat test_?.txt                              # A question mark (“?”) can be used to indicate “any single character” within the file name
cat test_*                                  # An asterisk (“*”) can be used to indicate “zero or more characters”. These are sometimes referred to as “wildcard” characters

echo "This is a test"   # echo just prints its arguments back out again (hence the name).
echo "This is a test" > test_1.txt          # capture the output of "echo" command as a text file "text_1.txt"
cat t* >> combined.txt              # to append to, rather than replace, the content of the existing files, double up on the greater-than character.
echo "I've appended a line!" >> combined.txt




w               # Prints All active SSH sessions on the server
who             # Prints your Current Active Session details
whoami          # the whoami command print current username



################# 




# vmstat network traffic monitor

# To See Daily Traffic of whole month
vmstat -d

# To see monthly traffic
vmstat -m #monthly traffic

vmstat -y # Yearly traffic

vmstat -h # hourly traffic

man vmstat # for more info on vmstat



