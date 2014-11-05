if defined?(ChefSpec)
  def create_consul_alerts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_alerts, :create, resource_name)
  end

  def remove_consul_alerts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_alerts, :remove, resource_name)
  end

  def start_consul_alerts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_alerts, :start, resource_name)
  end

  def stop_consul_alerts(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_alerts, :stop, resource_name)
  end
end
