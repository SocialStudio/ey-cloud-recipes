#
# Cookbook Name:: rapnd
# Recipe:: default
#

if ['solo', 'app_master', 'app'].include?(node[:instance_role]) || node[:instance_role] == 'util' && node[:name].include?('main')
  gem_package "rapnd-mikec54088" do 
    source "http://rubygems.org" 
    action :install 
    version "0.5.2"
  end
  
  node[:applications].each do |app, data|
    appname = app

    template "/etc/monit.d/rapnd_#{appname}.monitrc" do
      owner 'root' 
      group 'root' 
      mode 0644
      source "monitrc.conf.erb"
      variables({
        :appname => appname,
        :rails_env => node[:environment][:framework_env]
      })
    end
  end
  
  execute "ensure-rapnd-is-setup-with-monit" do 
    epic_fail true
    command %Q{ 
    monit reload 
    } 
  end
end
