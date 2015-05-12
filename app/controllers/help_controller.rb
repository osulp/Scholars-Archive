class HelpController < ApplicationController

  def faculty
    @page = ContentBlock.find_or_create_by( name: "help_faculty")
  end
  def graduate
    @page = ContentBlock.find_or_create_by( name: "help_graduate")
  end
  def undergraduate
    @page = ContentBlock.find_or_create_by( name: "help_undergraduate")
  end
  def general
    @page = ContentBlock.find_or_create_by( name: "help_general")
  end

end
