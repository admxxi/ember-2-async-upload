import { humanReadableFileSize } from 'ember-app/helpers/human-readable-file-size'
import { module, test } from 'qunit'

module 'Unit | Helper | human readable file size'

# Replace this with your real tests.
test 'it works', (assert) ->
  result = humanReadableFileSize 42
  assert.ok result
