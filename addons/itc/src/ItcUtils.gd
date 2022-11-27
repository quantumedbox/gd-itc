extends Object
class_name ItcUtils

# todo: Centralized logging

static func read_file(filepath: String) -> String:
  var file = File.new()
  if file.open(filepath, File.READ) != OK:
    return ""
  var result = file.get_as_text()
  file.close()
  return result


static func get_file_modification_time(filepath: String) -> int:
  ## Return unix time of file modification, or -1 on error
  var file = File.new()
  var result = file.get_modified_time(filepath)
  if typeof(result) == TYPE_STRING:
    return -1
  return result


static func save_to_file(filepath: String, content) -> bool:
  assert(not filepath.empty())
  var dir := Directory.new()
  if dir.make_dir_recursive(filepath.get_base_dir()) != OK:
    return false
  var file = File.new()
  if file.open(filepath, File.WRITE) != OK:
    return false
  if content is String:
    file.store_string(content)
  elif content is PoolByteArray:
    file.store_buffer(content)
  else:
    # todo: Serialize whatever it is
    assert(false, "ITC: Invalid type for save_to_file, should be String or PoolByteArray")
  file.close()
  return true


static func invoke(file: String, args: Array, output: Array = []) -> int: # Status Code
  # todo: Optionally capture output?
  print_debug("ITC: Invoking: ", file, ": ", args)
  if OS.get_name() == "Windows":
    return OS.execute("CMD.EXE", ["/C", file] + args, true, output)
  else:
    return OS.execute(file, args, true, output)


static func absolute_path(path: String) -> String:
  return ProjectSettings.globalize_path(path)


static func ensure_directory_for(filepath: String) -> bool:
  return Directory.new().make_dir_recursive(filepath.get_base_dir()) == OK
