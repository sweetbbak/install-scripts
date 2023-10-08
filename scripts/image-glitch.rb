#!/usr/bin/env ruby
# frozen_string_literal: true

# image-glitch.rb
# Author: William Woodruff
# ------------------------
# 'Glitch' an image by repeatedly compositing it over itself at various
# coordinates and in various fashions.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

require "rmagick"

composite_operators = [
  Magick::AddCompositeOp,
  Magick::AtopCompositeOp,
  Magick::BumpmapCompositeOp,
  Magick::ColorBurnCompositeOp,
  Magick::ColorDodgeCompositeOp,
  Magick::ColorizeCompositeOp,
  Magick::HardLightCompositeOp,
  Magick::HueCompositeOp,
  Magick::InCompositeOp,
  Magick::LightenCompositeOp,
  Magick::LinearBurnCompositeOp,
  Magick::LinearDodgeCompositeOp,
  Magick::LinearLightCompositeOp,
  Magick::LuminizeCompositeOp,
  Magick::MultiplyCompositeOp,
  Magick::PegtopLightCompositeOp,
  Magick::PinLightCompositeOp,
  Magick::PlusCompositeOp,
  Magick::ReplaceCompositeOp,
  Magick::SaturateCompositeOp,
  Magick::SoftLightCompositeOp,
  Magick::VividLightCompositeOp,
  Magick::XorCompositeOp,
]

file, level = ARGV.shift(2)

level = level.nil? ? 10 : Integer(level)

if file.nil?
  puts "Usage: #{$PROGRAM_NAME} <image> [glitch level]"
  exit 1
end

in_image = Magick::Image.read(file).first
out_image = in_image.dup

width = in_image.columns
height = in_image.rows

level.times do
  start_x = rand(0...width)
  start_y = rand(0...height)

  case rand(1..4)
  when 1
    out_image.composite!(in_image, start_x, start_y, composite_operators.sample)
  when 2
    out_image.composite!(in_image, -start_x, start_y, composite_operators.sample)
  when 3
    out_image.composite!(in_image, start_x, -start_y, composite_operators.sample)
  when 4
    out_image.composite!(in_image, -start_x, -start_y, composite_operators.sample)
  end
end

out_image.write("glitch.png")

