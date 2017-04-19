#!/bin/bash
#Getting the curent screen width
 width_screen=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
 height=180 #in pixels, height of the terminal
 delay_dd=0.001 #delay for the dropdown expand and hide, small is fast
 step=7 #step for the dropdown expand and hide
#substract 10px

Current_dir=$(pwd) #I was trying to open the terminal in the working directory, but i failed. It's opening always in the $USER
width_screen=$((width_screen-10))#i substracted 10px because it was bigger than my screen

if test $(wmctrl -l | grep "DropDownTx" | wc -l) -ne 0
#We test to see if there is a window opened with the name "DropDownTx"
then
  #The window already exists, so we close it. Also killing the process
  win_id=$(wmctrl -l | grep "DropDownTx" | awk '{print $1}')
  #Here we get the PID of the process, so we can kill it
  win_pid=$(xprop -id $win_id | grep "PID" |awk '/PID/ {print $3}')
  #Begin the hide process
  for((c=$height; c>=0; c=c-$step))
  do
    #We are reducing the height of the terminal step by step
    $(wmctrl -r "DropDownTX" -e 0,0,-25,$width_screen,$c) #resize and position the box: maxWidth X 180 , position: top left
    #I added -25 at left position, so it won't show the title panel, if you have another suggestion please tell me
    #Because i searched alot and i could't find something to hide that toolbar
    sleep $delay_dd
  done
  #End hide
  kill $win_pid #kill the process
else
  #There is no window named "DropDownTx" opened, so we will open one
	$(xterm -bg "#161616" -geometry 200x1+0+-65 -fa "Monospace Bold" -fg green -fs 9  -name "DropDownTx" -xrm 'XTerm.vt100.allowTitleOps: false' -title "DropDownTx" -e "cd $Current_dir && /bin/bash") &
  #XTerm fields:
    #-bg color -> Color of the background of the terminal. Can be also names, ex: -bg red, -bg "#ffffff"
    #-geometry ColumnsxLines+top+left -> columns and lines is in number of chars(used for the size of the window),I added -65 so it won't be vissible on the screen when it's opened
    # top and left is in pixels(used for the position)
    #-fa "Font_Name"
    #-fg color -> color of the font
    #-fs size -> size of the font
    #-name "Name_of_Window"
    #-xrm 'XTerm.vt100.allowTitleOps: false' -> This way we allow to modify the title of the window using the next field
    # -title "DropDownTx" -> setting the title
    # -e "cd $Current_dir && /bin/bash" -> I was trying to make it open in the current working directory, but it's allways the same $USER
	#Now we wait for the window to open and check each $delay_dd seconds
  for((c=0; c<=1000; c++))
  do
    if test $(wmctrl -l | grep "DropDownTx" | wc -l) -eq 1
    then
      #The window is opened now, so we will end this loop
      echo "\n Cat o luat - $c" >> ~/Apps/dropdown_Terminal/log
      break;
    fi
    sleep $delay_dd
  done

	$(wmctrl -r "DropDownTx" -b add,sticky) #I don't know what this does, but it sounds like it will always stay on top, like above
	$(wmctrl -r "DropDownTx" -b add,maximized_horz) #maximum width
	$(wmctrl -r "DropDownTx" -b add,skip_pager,skip_taskbar) #doesn't show in the panel: window list
	$(wmctrl -r "DropDownTx" -b add,above) #force it to stay above all windows
	#Begin expand
  for((c=0; c<=$height; c=c+$step))
  do
    $(wmctrl -r "DropDownTX" -e 0,0,-25,$width_screen,$c) #resize and position the box: maxWidth X 180 , position: top left
    sleep $delay_dd
  done
  #End expand
	$(wmctrl -r "DropDownTX" -e 0,0,-25,$width_screen,$height) #resize and position the box: maxWidth X 180 , position: top left
fi
exit 0
