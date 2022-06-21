tool
extends HTTPRequest

signal finished(result)


func _init() -> void:
  use_threads = true


class RequestResult extends Resource:
  var result: int
  var response_code: int
  var headers: PoolStringArray
  var body: PoolByteArray


func request_get(url: String) -> int: # Error
  assert(not url.empty())
  if connect("request_completed", self, "_on_request_completed") != OK:
    assert(false, "Cannot connect signal")
  return request(url)


func request_file(url: String, file_path: String) -> int: # Error
  assert(not url.empty())
  assert(not file_path.empty())
  download_file = file_path
  if connect("request_completed", self, "_on_request_completed_file") != OK:
    assert(false, "Cannot connect signal")
  return request(url)


func _on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
  var output := RequestResult.new()
  output.result = result
  output.response_code = response_code
  output.headers = headers
  output.body = body
  emit_signal("finished", output)
  # todo: Disconnect `_on_request_completed` after that?


func _on_request_completed_file(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
  emit_signal("finished", null)
  # todo: Disconnect `_on_request_completed_file` after that?
