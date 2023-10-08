import ueberzug.lib.v0 as ueberzug
import time

if __name__ == '__main__':
    with ueberzug.Canvas() as c:
        paths = ['/home/sweet/Pictures/1500x500.jpg', '/home/sweet/Pictures/FFaJd9RakAAzH4O.jpg']
        demo = c.create_placement('demo', x=0, y=0, scaler=ueberzug.ScalerOption.COVER.value)
        demo.path = paths[1]
        demo.visibility = ueberzug.Visibility.VISIBLE

        for i in range(30):
            with c.lazy_drawing:
                demo.x = i * 3
                demo.y = i * 3
                demo.path = paths[i % 2]
            time.sleep(1)

        time.sleep(2)