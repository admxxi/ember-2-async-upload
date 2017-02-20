import { test, moduleForComponent } from 'ember-qunit'
import hbs from 'htmlbars-inline-precompile'

moduleForComponent 'drop-zone', 'Integration | Component | drop zone', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{drop-zone}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#drop-zone}}
      template block text
    {{/drop-zone}}
  """

  assert.equal @$().text().trim(), 'template block text'
