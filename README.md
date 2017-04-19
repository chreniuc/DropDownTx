# DropDownTx
DropDownTx - It's a simple scripts that opens a XTerm like a dropdown. I also tried Guake, but i didn't like it because it was always running in the background(it didn't kill it when i closed). This scripts kills the process when a window with the name "DropDownTx" is opened, if it doesn't find a window it will start a new fresh one.

### Dependices

What things you need to install the script:
  * **wmctrl** - window manipulation
  * **xrandr** - to get the screen size
  * **xprop** - to get the PID using the ID of a window
  * [optional]**xbindkeys** - to execute the script using a keyboard shortcut

### Instructions

**Making the script executable:**

```
$ chmod +x terminal.sh
```


**Installing xbindkeys**
```
$ sudo apt-get install xbindkeys
```
**Create default settings for xbindkeys**
```
$ xbindkeys --defaults > /.xbindkeysrc
```
**adding keyboard Shortcut, mine is: "Ctrl + <", after that we restart xbindkeys**

**Add your path to teh script**
```
$ printf '#DropDownTx\n"/path/to/terminal.sh"\nControl + less\n' >> ~/.xbindkeysrc &&
```
**Restarting xbindkeys, so the changes will take effect**
```
$ killall xbindkeys ; xbindkeys
```
**Installing wmctrl**
```
$ sudo apt-get install wmctrl
```
### Features that i want to add:
* transparent background, without using Compiz(let me know if you have some ideas)

## Authors

* **Kznamst** - [Kznamst](https://github.com/kznamst)

See also the list of [contributors](https://github.com/kznamst/DropDownTx/contributors) who participated in this project.

## License

This project is licensed under the GNU General Public License.


