
class Mandelbrot
  def initialize(size, max_repeats)
    @size = size
    @max_repeats = max_repeats
  end

  def calculate(coord_bounds, set_pixel, progress_report)
    escape_radius = coord_bounds.map {|x| x[1] - x[0]}.max
    scales = [0,1].map { |i|
      (coord_bounds[i][1] - coord_bounds[i][0]).to_f / @size[i]
    }

    cplx = nil
    (0...@size.last).each do |img_y|
      (0...@size.first).each do |img_x|
        cplx = Complex(img_x * scales[0] + coord_bounds[0][0],
                       img_y * scales[1] + coord_bounds[1][0])
        z = 0
        rep = 0

        begin
          z = z ** 2 + cplx
          rep += 1
        end until rep >= @max_repeats or z.abs >= escape_radius

        if rep == @max_repeats
          set_pixel.call([img_x, img_y], :white)
        else
          set_pixel.call([img_x, img_y], [rep/@max_repeats.to_f * 255, 0, 255])
        end
      end
      progress_report.call(img_y, @size[1]) if progress_report
    end

  end
end


