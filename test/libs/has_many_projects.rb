module HasManyProjects
  def projects
    Project.by_project_id :key => id
  end
end