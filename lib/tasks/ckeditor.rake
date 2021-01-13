require 'fileutils'

desc "Copy plugin"
task "ckeditor:copy:plugins" => :environment do
  source = Rails.root.join('app', 'assets', 'javascripts', 'ckeditor', 'plugins')
  dest = Rails.root.join('public', 'assets', 'ckeditor', 'plugins')
  FileUtils.copy_entry source, dest
end

# auto run ckeditor:create_nondigest_assets after assets:precompile
Rake::Task['assets:precompile'].enhance do
  Rake::Task['ckeditor:copy:plugins'].invoke
end
