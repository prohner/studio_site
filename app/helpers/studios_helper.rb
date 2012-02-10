module StudiosHelper
  def gravatar_for(studio, options = { :size => 50 })
    gravatar_image_tag(studio.email.downcase, :alt => h(studio.name),
                                              :class => 'gravatar',
                                              :gravatar => options)
  end
  
  def can_edit_studio
    current_studio?(@studio)
  end
end
