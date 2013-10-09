module Charting
  require 'googlecharts'
  def profile_image_url
    return unless samples.present?
    return "image" if Rails.env.test?

    Gchart.line(
    :title => 'logdives.com',
    :axis_with_labels => 'x,y', :size => '400x300',
    :data => adjusted_y,
    :axis_range => axis_range
    )
  end

  def adjusted_y
    y_samples.map{|s| max_y_rounded - s}
  end

  def x_samples
    x = samples.map{|s| (s[0].to_i/60) }
    [0] + x + [x.last + 1]
  end

  def y_samples
    [0] + samples.map{|s| (s[1].to_f) } + [0]
  end

  def x_axis_range
    [0, x_samples.last.roundup(5), 5]
  end

  def max_y_rounded
    y_samples.sort!{|a,b| a <=> b}.last.roundup(5)
  end

  def y_axis_range
    [ max_y_rounded,0,-5]
  end

  def axis_range
    [x_axis_range, y_axis_range]
  end
end