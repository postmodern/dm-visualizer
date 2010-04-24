module Helpers
  module Project
    PROJECTS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'projects'))

    def project_dir(name)
      File.join(PROJECTS_DIR,name)
    end
  end
end
