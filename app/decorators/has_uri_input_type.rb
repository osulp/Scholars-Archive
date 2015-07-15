# Decorator for ScholarsArchive::Fields::InputFactory to allow the URI-enabled
# input type.
#
# @note We purposely don't allow single-value URI-enabled fields for now, and
# those will just fall through here with no changes.
class HasURIInputType < SimpleDelegator
  def options
    if has_multiple?
      super.merge(:as => :uri_multi_value)
    else
      super
    end
  end

  private

  def has_multiple?
    object.class.multiple?(property)
  end
end
