namespace 'db' do
  desc "Loading all models and their methods in roles table."
  task(:add_roles_permissions => :environment) do

    data = YAML.load_file("lib/tasks/data/role_permissions.yaml")
    data.each do |r|
      permission_arr = []
      lists = r['permissions'] || []
      lists.each do |p|
        controller = p['controller']
        actions = p['actions']
        pms = Permission.where(:subject_class => controller, :action => actions)
        pms.each do |pers|
          permission_arr << pers 
        end
      end

      role_name = r['role_name']
      level = r['level']
      Role.create(:name => role_name, :level => level, :permissions => permission_arr)
    end
  end
end
