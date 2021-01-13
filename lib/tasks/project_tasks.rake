# coding: utf-8

namespace :project do
  desc "project tasks"
  task :tasks do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    #Rake::Task["db:add_permissions"].invoke #根据zh-cn配置文件中authorities的配置内容来添加权限,添加对应action和title即可
    #Rake::Task["db:add_roles_permissions"].invoke #在data/role_permissions中设置默认角色和对应权限,这一步要在add_permission之后
    #Rake::Task["assets:precompile"].invoke
    #Rake::Task["kindeditor:assets"].invoke
  end
end
