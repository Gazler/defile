require 'thor'
module Defile
  class CLI < Thor
    #HOME_DIR = Dir.home
    HOME_DIR = Dir.home
    DEFAULT_DIR = File.join(HOME_DIR, ".defile")

    default_task :user

    desc "user [NAME]", "Download dotfiles from GitHub [NAME]"
    def user(name = nil)
      help if name.nil?
    end

    desc :package, "Package your dotfiles into a git repository"
    def package
      make_and_move_dir(DEFAULT_DIR)
      Dir.mkdir("backup") unless File.exists?("backup")
      Parser.parse
      Dir.chdir("backup")
      `git init`
      `git add .`
      `git commit -m "Defile package"`
    end

    desc :link, "Create a symlink in your home dir for each file"

    def link
      Dir.chdir(HOME_DIR)
      Dir.glob("#{DEFAULT_DIR}/{*,.*}").each do |file|
        next if Constants::IGNORE_FILES.include?(file.split("/").last)
        File.symlink(file, file.split("/").last)
      end
    end

    no_tasks do

      def make_and_move_dir(dir)
        Dir.mkdir(dir) unless File.exists?(dir)
        Dir.chdir(dir)
      end
    end

  end
end
