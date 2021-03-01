# frozen_string_literal:true

Hydra::Derivatives::Processors::Image.class_eval do
  protected
  def create_resized_image
    create_image do |xfrm|
      if size
        # Combine all ImageMagick options together and add the `-type TrueColor` option to preserve colorspace information
        # This is a fix as described in https://github.com/osulp/Scholars-Archive/issues/2143
        xfrm.combine_options do |x|
          x.flatten
          x.alpha('remove')
          x.type('TrueColor')
          x.resize(size)
        end
      end
    end
  end
end
