# {{ansible_managed}}
#
 
all_spec= Specification.find_or_create_by_data! 'substitute_with_path: cider-ci/all_tests.yml'
Definition.find_by(name: "All Tests").try(&:destroy)
Definition.find_or_create_by(name: "All tests").update_attributes! \
  description: "Loads the specification from the repository path 'cider-ci/all_tests.yml'.",
  specification: all_spec

hotspots_spec= Specification.find_or_create_by_data! 'substitute_with_path: cider-ci/hotspots.yml'
Definition.find_or_create_by(name: "Hotspots", specification_id: hotspots_spec.id).update_attributes! \
  description: "Loads the specification from the repository path 'cider-ci/hotspots.yml'."



{% for executor in groups['cider-ci-executors'] %}
executor=Executor.find_or_initialize_by(name: "{{executor}}")
executor.update_attributes!(
  host: "{{hostvars[executor]['ansible_default_ipv4']['address']}}",
  port: "{{executor_service_https_port}}",
  traits: (executor.traits || []).concat([
    {% for trait in traits %}
      '{{trait}}',
    {% endfor %}
    ]).sort.uniq,
  ssl: true
)
{% endfor %}

ServerSettings.find.update_attributes! \
  ui_context: '/{{web_sub_path}}',
  api_context: '/{{web_sub_path}}',
  repositories_path: '{{repositories_path}}',
  server_host: '{{ansible_default_ipv4['address']}}'

