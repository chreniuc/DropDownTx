#!/bin/bash
#Author:
#DropDownTx plugin made by Kznamst https://github.com/kznamst/

#Getting the curent screen width
 width_screen=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
 height=180 #in pixels, height of the terminal
 delay_dd=0.001 #delay for the dropdown expand and hide, small is fast
 scroll_speed=7 #step for the dropdown expand and hide
#substract 10px

Current_dir=$(pwd) #I was trying to open the terminal in the working directory, but i failed. It's opening always in the $USER
width_screen=$((width_screen-10))#i substracted 10px because it was bigger than my screen

scroll_window() {
  if test $1 -eq 0
  then
    local start=$height
    local step=$((-1*$scroll_speed))
    local stop=0
  else
    local start=0
    local step=$scroll_speed
    local stop=$height
  fi
  for c in $(seq $start $step $stop)
  do
    $(wmctrl -r "DropDownTX7683" -e 0,0,-25,$width_screen,$c) #resize and position the box: maxWidth X 180 , position: top left
    #I added -25 at left position, so it won't show the title panel, if you have another suggestion please tell me
    #Because i searched alot and i could't find something to hide that toolbar
    sleep $delay_dd
  done
}

if test $(wmctrl -l | grep "DropDownTx7683" | wc -l) -ne 0
#We test to see if there is a window opened with the name "DropDownTx7683"
then
  #The window already exists, so test if it's hidden or not
  win_id=$(wmctrl -l | grep "DropDownTx7683" | awk '{print $1}')
  if xprop -id $win_id | grep "_NET_WM_STATE_ABOVE"
  #If the window has the above property, then we scroll it up and hide it. If not then we show it and scroll it down
  then
    scroll_window 0
    $(wmctrl -r "DropDownTx7683" -b remove,above)
    $(wmctrl -r "DropDownTx7683" -b add,hidden)
  else
    $(wmctrl -r "DropDownTx7683" -b remove,hidden)
    $(wmctrl -r "DropDownTx7683" -b add,above)
    scroll_window 1
    $(wmctrl -a "DropDownTx7683")
  fi
else
  #There is no window named "DropDownTx" opened, so we will open one
  $(xterm -bg "#161616" -geometry 200x1+0+-65 -fa "Monospace Bold" -fg green -fs 9  -name "DropDownTx7683" -xrm 'XTerm.vt100.allowTitleOps: false' -title "DropDownTx7683" -e "cd $Current_dir && /bin/bash") &
  #XTerm fields:
    #-bg color -> Color of the background of the terminal. Can be also names, ex: -bg red, -bg "#ffffff"
    #-geometry ColumnsxLines+top+left -> columns and lines is in number of chars(used for the size of the window),I added -65 so it won't be vissible on the screen when it's opened
    # top and left is in pixels(used for the position)
    #-fa "Font_Name"
    #-fg color -> color of the font
    #-fs size -> size of the font
    #-name "Name_of_Window"
    #-xrm 'XTerm.vt100.allowTitleOps: false' -> This way we allow to modify the title of the window using the next field
    # -title "DropDownTx7683" -> setting the title
    # -e "cd $Current_dir && /bin/bash" -> I was trying to make it open in the current working directory, but it's allways the same $USER
	#Now we wait for the window to open and check each $delay_dd seconds
  for((c=0; c<=1000; c++))
  do
    if test $(wmctrl -l | grep "DropDownTx7683" | wc -l) -eq 1
    then
      #The window is opened now, so we will end this loop
      break;
    fi
    sleep $delay_dd
  done

  $(wmctrl -r "DropDownTx7683" -b add,sticky) #I don't know what this does, but it sounds like it will always stay on top, like above
  $(wmctrl -r "DropDownTx7683" -b add,maximized_horz) #maximum width
  $(wmctrl -r "DropDownTx7683" -b add,skip_pager,skip_taskbar) #doesn't show in the panel: window list
  $(wmctrl -r "DropDownTx7683" -b add,above) #force it to stay above all windows
  scroll_window 1
  # $(wmctrl -r "DropDownTx7683" -e 0,0,-25,$width_screen,$height) #resize and position the box: maxWidth X 180 , position: top left
fi
exit 0
