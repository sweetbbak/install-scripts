import curses
import time
from curses.textpad import Textbox, rectangle
import ueberzug.lib.v0 as ueberzug
  
  
@ueberzug.Canvas()
def main(stdscr, canvas):
    demo = canvas.create_placement('demo', x=10, y=0)
    stdscr.addstr(0, 0, "Enter IM message: (hit Ctrl-G to send)")

    editwin = curses.newwin(5, 30, 3, 1)
    rectangle(stdscr, 2, 0, 2+5+1, 2+30+1)
    stdscr.refresh()

    box = Textbox(editwin)

    # Let the user edit until Ctrl-G is struck.
    box.edit()

    # Get resulting contents
    message = box.gather()
    demo.path = ''.join(message.split())
    demo.visibility = ueberzug.Visibility.VISIBLE
    time.sleep(2)


if __name__ == '__main__':
    curses.wrapper(main)
