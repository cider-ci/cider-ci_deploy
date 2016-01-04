let url = """http://{{ci_virtual_hosts[0]['hostname']}}/cider-ci/ui/configuration_management_backdoor/invoke"""
let username = """admin"""
let password = """{{secret_key_base}}"""

let body = """
  executor= Executor.find_or_initialize_by(name: '{{inventory_hostname}}')
{% if executor_base_url is not none %}
   executor.update_attributes!(base_url: '{{executor_base_url}}')
{% else %}
   executor.update_attributes!(base_url: nil)
{%endif %}
  executor.reload
  "#{executor.id} #{executor.auth_password}"
"""

let postInvoke _ =
  let client = new System.Net.WebClient()
  client.Headers.Add("Content-Type", "application/ruby")
  let credentials = new System.Net.NetworkCredential(username, password)
  client.Credentials <- credentials
  let res = client.UploadString(url,body)
  printfn "%s" res
  ()

let handleFailure(ex : System.Exception)=
  eprintfn "%s" ex.Message
  exit -1

try
  postInvoke()
with
  | ex -> handleFailure(ex)
