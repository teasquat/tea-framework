mix_table = (list) ->
  result = {}

  for tab in *list
    for k, v in pairs tab
      result[k] = v

  result

{
  :mix_table
}
