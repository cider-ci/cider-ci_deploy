# {{ansible_managed}}
#
 
all_spec= Specification.find_or_create_by_data! 'substitute_with_path: cider-ci/all_tests.yml'
Definition.find_by(name: "All tests").try(&:destroy)
Definition.create name: "All tests" ,
  description: "Loads the specification from the repository path 'cider-ci/all_tests.yml'.",
  specification: all_spec


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


