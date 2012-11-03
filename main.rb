require 'RMagick'
require 'ruby-progressbar'

include Magick

COORD_SIZE = { :x => [-2, 1], :y => [-1, 1] }
MAX_REPEATS = 50
#IMG_SIZE = [200, 200]
IMG_MAGNITUDE = 1366
IMG_SIZE = [IMG_MAGNITUDE,
            ((COORD_SIZE[:y][1] - COORD_SIZE[:y][0]).to_f /
             (COORD_SIZE[:x][1] - COORD_SIZE[:x][0]) * IMG_MAGNITUDE).to_i]

X_SCALE = (COORD_SIZE[:x].last - COORD_SIZE[:x].first).to_f / IMG_SIZE.first
Y_SCALE = (COORD_SIZE[:y].last - COORD_SIZE[:y].first).to_f / IMG_SIZE.last
ESCAPE_RADIUS = COORD_SIZE.values.map {|x| x[1] - x[0]}.max

canvas = Image.new(*IMG_SIZE)
#pbar = ProgressBar.create(:total => IMG_SIZE.inject(1, &:*),
#                          :format => '%c/%C %E')

(0...IMG_SIZE.first).each do |img_x|
  (0...IMG_SIZE.last).each do |img_y|
    cplx = Complex(img_x * X_SCALE + COORD_SIZE[:x].first,
                   img_y * Y_SCALE + COORD_SIZE[:y].first)

    repeats = 0
    z = 0.to_c

    begin
      z *= z
      z += cplx
      repeats += 1
    end until z.abs >= ESCAPE_RADIUS or repeats >= MAX_REPEATS

    if repeats >= MAX_REPEATS
      pixel_color = 'white'
    else
      pixel_color = Pixel.new(repeats.to_f / MAX_REPEATS * 65535, 0, 65535)
    end

    canvas.pixel_color(img_x, img_y, pixel_color)
#    pbar.increment
  end
end

canvas.write('mandelbrot.png')
canvas.display




