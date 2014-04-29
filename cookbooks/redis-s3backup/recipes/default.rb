#
# Cookbook Name:: redis-s3backup
# Recipe:: default
#

if ['util'].include?(node[:instance_role])
  if node[:name].include?('redis')

    directory "/data/redis/s3backup" do
      owner 'redis'
      group 'redis'
      mode 0755
      action :create
    end

    remote_file "/usr/local/bin/redis-s3backup.sh" do
      source "redis-s3backup.sh"
      owner "root"
      group "root"
      mode  0700
      action :create
    end

    cron "run redis s3backups" do
      minute  '1'
      hour    '1'
      day     '*'
      month   '*'
      weekday '*'
      command "/usr/local/bin/redis-s3backup.sh"
    end
  end
end
