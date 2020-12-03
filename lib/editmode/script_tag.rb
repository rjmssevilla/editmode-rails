module Editmode
  class ScriptTag

    def self.generate(*args)
      new(*args).output
    end

    def initialize(project_id=Editmode.project_id)
      @project_id = project_id
    end

    def valid?
      true
    end

    def output
      str = <<-EDITMODE_SCRIPT
  <script>window.chunksProjectIdentifier = '#{@project_id}'</script>
  <script>window.editmodeENV = '#{ENV["EDITMODE_ENV"] || 'production'}'</script>
  <script src="#{script_url}" async ></script>
      EDITMODE_SCRIPT

      str.respond_to?(:html_safe) ? str.html_safe : str
    end

    def script_url
      ENV["EDITMODE_OVERRIDE_SCRIPT_URL"] || "https://static.editmode.com/editmode@2.0.0/dist/editmode.js"
    end
  end
end
