def create_service_factory(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:service_factory, :create, resource_name)
end
