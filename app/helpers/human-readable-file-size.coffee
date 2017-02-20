import Ember from 'ember'

# This function receives the params `params, hash`
humanReadableFileSize = (size) ->
  label = ''
  if size == 0
    label = '0 KB'
  else if size and !isNaN(size)
    fileSizeInBytes = size
    i = -1
    loop
      fileSizeInBytes = fileSizeInBytes / 1024
      i++
      unless fileSizeInBytes > 1024
        break
    byteUnits = [
      ' KB'
      ' MB'
      ' GB'
      ' TB'
      ' PB'
      ' EB'
      ' ZB'
      ' YB'
    ]
    label += Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i]
  label

export default Ember.Helper.helper humanReadableFileSize
