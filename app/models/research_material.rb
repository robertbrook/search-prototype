class ResearchMaterial < ContentObject

  def initialize(content_object_data)
    super
  end

  def template
    'search/objects/research_material'
  end

  def object_name
    'research material'
  end

end