

require 'rubygame'
require_relative 'mandelbrot_lib'

class Navigator
  include Rubygame

  attr :scr, :event_queue
  attr_reader :mandelbrot

  def initialize(size)
    @scr = Screen.new(size)
    @event_queue = EventQueue.new
    @zoom_scale = 2
    @max_repeats = 40
    @mandelbrot = Mandelbrot.new(@scr.size, @max_repeats)
    @coord_bounds = [[-2, 1], [-1, 1]]
    update_fractal
  end

  def zoom_in(click_pos)
    [0,1].map { |i|
      scale = (@coord_bounds[i][1] - @coord_bounds[i][0]).to_f
      a = (click_pos[i].to_f / @scr.size[i]) * scale + @coord_bounds[i][0]

      [a - scale / (2.0 * @zoom_scale),
       a + scale / (2.0 * @zoom_scale)]
    }
  end

  def zoom_out(click_pos)
    [0,1].map { |i|
      scale = (@coord_bounds[i][1] - @coord_bounds[i][0]).to_f

      a = (click_pos[i].to_f / @scr.size[i]) * scale + @coord_bounds[i][0]

      [a - scale * @zoom_scale / 2.0,
       a + scale * @zoom_scale / 2.0]
    }
  end

  def update_fractal
    puts @coord_bounds.inspect
    @mandelbrot.calculate(@coord_bounds,
                          proc {|pos, color|
                            @scr.set_at(pos, color)
                          }, proc {
                            @scr.update
                          })
  end

  def loop
    while e = @event_queue.wait
      case e
      when MouseUpEvent
        if e.button == 1 # left
          @coord_bounds = zoom_in(e.pos)
        elsif e.button == 3
          @coord_bounds = zoom_out(e.pos)
        end
        update_fractal
      when QuitEvent
        break
      else
        # p e
      end
    end
  end
end


if __FILE__ == $0
  Navigator.new([600, 400]).loop
end
