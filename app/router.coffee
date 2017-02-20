###
import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('hello');
});

export default Router;
###

`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @route('/')
  @route('index')
  @route('files')
  @route('notFiles')


`export default Router`
